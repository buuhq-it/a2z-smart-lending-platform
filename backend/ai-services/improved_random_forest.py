import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import cross_val_score, StratifiedKFold
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, roc_auc_score
from scipy.stats import entropy
import warnings
warnings.filterwarnings('ignore')

class ImprovedRandomForest:
    """
    Improved Random Forest with C5.0-inspired enhancements:
    1. Ensemble feature method with bagging
    2. Information gain ratio for split selection
    3. Enhanced node purity measures
    4. Optimized for class imbalance
    """
    
    def __init__(self, n_estimators=100, max_depth=None, min_samples_split=5, 
                 min_samples_leaf=2, feature_subsample_ratio=0.8, random_state=42):
        self.n_estimators = n_estimators
        self.max_depth = max_depth
        self.min_samples_split = min_samples_split
        self.min_samples_leaf = min_samples_leaf
        self.feature_subsample_ratio = feature_subsample_ratio
        self.random_state = random_state
        self.trees = []
        self.feature_subsets = []
        self.feature_importances_ = None
        self.classes_ = None
    
    def get_params(self, deep=True):
        """Get parameters for this estimator (sklearn compatibility)"""
        return {
            'n_estimators': self.n_estimators,
            'max_depth': self.max_depth,
            'min_samples_split': self.min_samples_split,
            'min_samples_leaf': self.min_samples_leaf,
            'feature_subsample_ratio': self.feature_subsample_ratio,
            'random_state': self.random_state
        }
    
    def set_params(self, **params):
        """Set parameters for this estimator (sklearn compatibility)"""
        for key, value in params.items():
            setattr(self, key, value)
        return self
        
    def _calculate_information_gain_ratio(self, X, y, feature_idx, threshold):
        """
        Calculate information gain ratio (C5.0 inspired) - OPTIMIZED VERSION
        """
        # Split data based on threshold
        left_mask = X[:, feature_idx] <= threshold
        left_count = np.sum(left_mask)
        right_count = len(y) - left_count
        
        if left_count == 0 or right_count == 0:
            return 0
        
        # Fast entropy calculation using bincount
        total_count = len(y)
        left_ratio = left_count / total_count
        right_ratio = right_count / total_count
        
        # Parent entropy (faster calculation)
        parent_counts = np.bincount(y)
        parent_probs = parent_counts / total_count
        parent_entropy = -np.sum(parent_probs * np.log2(parent_probs + 1e-10))
        
        # Child entropies
        left_counts = np.bincount(y[left_mask])
        if len(left_counts) < 2:
            left_counts = np.append(left_counts, [0] * (2 - len(left_counts)))
        left_probs = left_counts / left_count
        left_entropy = -np.sum(left_probs * np.log2(left_probs + 1e-10))
        
        right_counts = np.bincount(y[~left_mask])
        if len(right_counts) < 2:
            right_counts = np.append(right_counts, [0] * (2 - len(right_counts)))
        right_probs = right_counts / right_count
        right_entropy = -np.sum(right_probs * np.log2(right_probs + 1e-10))
        
        # Information gain
        weighted_entropy = left_ratio * left_entropy + right_ratio * right_entropy
        info_gain = parent_entropy - weighted_entropy
        
        # Split information for gain ratio
        split_info = -(left_ratio * np.log2(left_ratio + 1e-10) + right_ratio * np.log2(right_ratio + 1e-10))
        
        # Information gain ratio
        gain_ratio = info_gain / (split_info + 1e-10)
        
        return gain_ratio
    
    def _ensemble_feature_selection(self, X, y):
        """
        FAST ensemble feature selection with C5.0 inspiration
        """
        n_features = X.shape[1]
        n_features_subset = int(n_features * self.feature_subsample_ratio)
        
        # Fast feature scoring using sample-based approach
        feature_scores = np.zeros(n_features)
        
        # Sample only a subset of thresholds for speed
        max_thresholds_per_feature = 10
        
        for feature_idx in range(n_features):
            feature_values = X[:, feature_idx]
            
            # Use percentiles instead of all unique values for speed
            percentiles = np.linspace(10, 90, max_thresholds_per_feature)
            thresholds = np.percentile(feature_values, percentiles)
            
            max_gain_ratio = 0
            for threshold in thresholds:
                gain_ratio = self._calculate_information_gain_ratio(X, y, feature_idx, threshold)
                max_gain_ratio = max(max_gain_ratio, gain_ratio)
            
            feature_scores[feature_idx] = max_gain_ratio
        
        # Fast correlation calculation for positive class bias
        positive_class_mask = y == 1
        if np.sum(positive_class_mask) > 0:
            # Vectorized correlation calculation
            X_std = (X - np.mean(X, axis=0)) / (np.std(X, axis=0) + 1e-10)
            y_std = (positive_class_mask.astype(float) - np.mean(positive_class_mask)) / (np.std(positive_class_mask) + 1e-10)
            correlations = np.abs(np.dot(X_std.T, y_std) / len(y))
            feature_scores += 0.1 * correlations  # Small bias boost
        
        # Select top features based on scores
        top_feature_indices = np.argsort(feature_scores)[-n_features_subset:]
        
        return top_feature_indices
    
    def _create_enhanced_tree(self, X_subset, y_subset, feature_subset):
        """
        Create decision tree with enhanced splitting criteria
        """
        tree = DecisionTreeClassifier(
            max_depth=self.max_depth,
            min_samples_split=self.min_samples_split,
            min_samples_leaf=self.min_samples_leaf,
            criterion='gini',  # Using gini with our custom feature selection
            random_state=self.random_state,
            class_weight='balanced'  # Handle any remaining imbalance
        )
        
        tree.fit(X_subset, y_subset)
        return tree
    
    def fit(self, X, y):
        """
        Fit the improved random forest model
        """
        print("Training Improved Random Forest...")
        
        # Convert to numpy arrays
        if isinstance(X, pd.DataFrame):
            X = X.values
        if isinstance(y, pd.Series):
            y = y.values
            
        self.classes_ = np.unique(y)
        n_samples, n_features = X.shape
        
        # Initialize containers
        self.trees = []
        self.feature_subsets = []
        
        np.random.seed(self.random_state)
        
        for i in range(self.n_estimators):
            # Bootstrap sampling
            bootstrap_indices = np.random.choice(n_samples, size=n_samples, replace=True)
            X_bootstrap = X[bootstrap_indices]
            y_bootstrap = y[bootstrap_indices]
            
            # Enhanced feature selection (optimized)
            selected_features = self._ensemble_feature_selection(X_bootstrap, y_bootstrap)
            X_feature_subset = X_bootstrap[:, selected_features]
            
            # Create and train tree
            tree = self._create_enhanced_tree(X_feature_subset, y_bootstrap, selected_features)
            
            self.trees.append(tree)
            self.feature_subsets.append(selected_features)
            
            if (i + 1) % 10 == 0:  # More frequent progress updates
                print(f"  Trained {i + 1}/{self.n_estimators} trees")
        
        # Calculate feature importances
        self._calculate_feature_importances(X, n_features)
        
        print("Improved Random Forest training completed!")
        return self
    
    def _calculate_feature_importances(self, X, n_features):
        """
        Calculate aggregate feature importances across all trees
        """
        feature_importances = np.zeros(n_features)
        
        for tree, feature_subset in zip(self.trees, self.feature_subsets):
            tree_importances = tree.feature_importances_
            for i, feature_idx in enumerate(feature_subset):
                feature_importances[feature_idx] += tree_importances[i]
        
        # Normalize
        feature_importances = feature_importances / self.n_estimators
        self.feature_importances_ = feature_importances / np.sum(feature_importances)
    
    def predict_proba(self, X):
        """
        Predict class probabilities
        """
        if isinstance(X, pd.DataFrame):
            X = X.values
            
        n_samples = X.shape[0]
        n_classes = len(self.classes_)
        probabilities = np.zeros((n_samples, n_classes))
        
        for tree, feature_subset in zip(self.trees, self.feature_subsets):
            X_subset = X[:, feature_subset]
            tree_proba = tree.predict_proba(X_subset)
            probabilities += tree_proba
        
        # Average probabilities
        probabilities = probabilities / self.n_estimators
        return probabilities
    
    def predict(self, X):
        """
        Predict class labels
        """
        probabilities = self.predict_proba(X)
        return self.classes_[np.argmax(probabilities, axis=1)]
    
    def score(self, X, y):
        """
        Calculate accuracy score
        """
        predictions = self.predict(X)
        return accuracy_score(y, predictions)


class StandardRandomForest:
    """
    Standard Random Forest wrapper for comparison
    """
    
    def __init__(self, n_estimators=100, max_depth=None, min_samples_split=5,
                 min_samples_leaf=2, random_state=42):
        self.n_estimators = n_estimators
        self.max_depth = max_depth
        self.min_samples_split = min_samples_split
        self.min_samples_leaf = min_samples_leaf
        self.random_state = random_state
        self.model = RandomForestClassifier(
            n_estimators=n_estimators,
            max_depth=max_depth,
            min_samples_split=min_samples_split,
            min_samples_leaf=min_samples_leaf,
            random_state=random_state,
            class_weight='balanced'  # Handle class imbalance
        )
    
    def get_params(self, deep=True):
        """Get parameters for this estimator (sklearn compatibility)"""
        return {
            'n_estimators': self.n_estimators,
            'max_depth': self.max_depth,
            'min_samples_split': self.min_samples_split,
            'min_samples_leaf': self.min_samples_leaf,
            'random_state': self.random_state
        }
    
    def set_params(self, **params):
        """Set parameters for this estimator (sklearn compatibility)"""
        for key, value in params.items():
            setattr(self, key, value)
        # Recreate model with new parameters
        self.model = RandomForestClassifier(
            n_estimators=self.n_estimators,
            max_depth=self.max_depth,
            min_samples_split=self.min_samples_split,
            min_samples_leaf=self.min_samples_leaf,
            random_state=self.random_state,
            class_weight='balanced'
        )
        return self
        
    def fit(self, X, y):
        print("Training Standard Random Forest...")
        self.model.fit(X, y)
        print("Standard Random Forest training completed!")
        return self
    
    def predict(self, X):
        return self.model.predict(X)
    
    def predict_proba(self, X):
        return self.model.predict_proba(X)
    
    def score(self, X, y):
        return self.model.score(X, y)
    
    @property
    def feature_importances_(self):
        return self.model.feature_importances_ 