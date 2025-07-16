from flask import Flask, request, jsonify
from flask_restful import Api, Resource
import joblib
import pandas as pd
import numpy as np
import os
import logging
from datetime import datetime
import sys
import improved_random_forest

# No additional paths needed for this simple API

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class ModelService:
    """
    Service class for loading and managing the trained model
    """
    
    def __init__(self):
        self.model = None
        self.metadata = None
        self.preprocessor = None
        self.feature_names = None
        
    def load_model(self, model_path, metadata_path, preprocessor_path=None):
        """Load the trained model and metadata"""
        try:
            # Load model
            self.model = joblib.load(model_path)
            logger.info(f"Model loaded from: {model_path}")
            
            # Load metadata
            self.metadata = joblib.load(metadata_path)
            self.feature_names = self.metadata.get('feature_names', [])
            logger.info(f"Metadata loaded from: {metadata_path}")
            
            # Load preprocessor if available
            if preprocessor_path and os.path.exists(preprocessor_path):
                self.preprocessor = joblib.load(preprocessor_path)
                logger.info(f"Preprocessor loaded from: {preprocessor_path}")
            
            return True
            
        except Exception as e:
            logger.error(f"Error loading model: {str(e)}")
            return False
    
    def preprocess_input(self, input_data):
        """
        Preprocess input data to match training format
        """
        try:
            # Convert to DataFrame if it's a dict
            if isinstance(input_data, dict):
                input_df = pd.DataFrame([input_data])
            elif isinstance(input_data, list):
                input_df = pd.DataFrame(input_data)
            else:
                input_df = input_data
            
            # Basic validation - check if required features are present
            if self.feature_names:
                missing_features = set(self.feature_names) - set(input_df.columns)
                if missing_features:
                    # Fill missing features with default values
                    for feature in missing_features:
                        input_df[feature] = 0  # Default value
                
                # Ensure column order matches training data
                input_df = input_df[self.feature_names]
            
            return input_df
            
        except Exception as e:
            logger.error(f"Error preprocessing input: {str(e)}")
            raise
    
    def predict(self, input_data):
        """Make prediction on preprocessed input"""
        try:
            if self.model is None:
                raise ValueError("Model not loaded")
            
            # Preprocess input
            processed_data = self.preprocess_input(input_data)
            
            # Get prediction probabilities
            probabilities = self.model.predict_proba(processed_data)
            predictions = self.model.predict(processed_data)
            
            # Format results
            results = []
            for i in range(len(processed_data)):
                result = {
                    'prediction': int(predictions[i]),
                    'probability_default': float(probabilities[i][1]),
                    'probability_repaid': float(probabilities[i][0]),
                    'risk_level': self._get_risk_level(probabilities[i][1])
                }
                results.append(result)
            
            return results[0] if len(results) == 1 else results
            
        except Exception as e:
            logger.error(f"Error making prediction: {str(e)}")
            raise
    
    def _get_risk_level(self, default_probability):
        """Convert probability to risk level"""
        if default_probability < 0.3:
            return "Low"
        elif default_probability < 0.7:
            return "Medium"
        else:
            return "High"


# Initialize Flask app and model service
app = Flask(__name__)
api = Api(app)
model_service = ModelService()

class PredictResource(Resource):
    """Resource for single prediction"""
    
    def post(self):
        try:
            # Get input data
            input_data = request.get_json()
            
            if not input_data:
                return {'error': 'No input data provided'}, 400
            
            # Make prediction
            result = model_service.predict(input_data)
            
            return {
                'status': 'success',
                'prediction': result,
                'timestamp': datetime.now().isoformat()
            }, 200
            
        except ValueError as e:
            return {'error': str(e)}, 400
        except Exception as e:
            logger.error(f"Prediction error: {str(e)}")
            return {'error': 'Internal server error'}, 500

class BatchPredictResource(Resource):
    """Resource for batch predictions"""
    
    def post(self):
        try:
            # Get input data
            input_data = request.get_json()
            
            if not input_data or 'data' not in input_data:
                return {'error': 'No input data provided. Use {"data": [...]} format'}, 400
            
            data_list = input_data['data']
            
            if not isinstance(data_list, list):
                return {'error': 'Data must be a list of objects'}, 400
            
            # Make predictions
            results = model_service.predict(data_list)
            
            return {
                'status': 'success',
                'predictions': results,
                'count': len(results),
                'timestamp': datetime.now().isoformat()
            }, 200
            
        except ValueError as e:
            return {'error': str(e)}, 400
        except Exception as e:
            logger.error(f"Batch prediction error: {str(e)}")
            return {'error': 'Internal server error'}, 500

class ModelInfoResource(Resource):
    """Resource for model information"""
    
    def get(self):
        try:
            if model_service.model is None:
                return {'error': 'Model not loaded'}, 500
            
            info = {
                'model_name': model_service.metadata.get('model_name', 'Unknown'),
                'timestamp': model_service.metadata.get('timestamp', 'Unknown'),
                'feature_count': len(model_service.feature_names) if model_service.feature_names else 0,
                'model_type': str(type(model_service.model).__name__),
                'status': 'ready'
            }
            
            # Add performance metrics if available
            if 'results' in model_service.metadata:
                results = model_service.metadata['results']
                info['performance'] = {
                    'cv_accuracy': results.get('cv_accuracy', {}).get('mean', 'N/A'),
                    'cv_f1': results.get('cv_f1', {}).get('mean', 'N/A'),
                    'cv_auc': results.get('cv_auc', {}).get('mean', 'N/A')
                }
            
            return info, 200
            
        except Exception as e:
            logger.error(f"Model info error: {str(e)}")
            return {'error': 'Internal server error'}, 500

class HealthResource(Resource):
    """Health check resource"""
    
    def get(self):
        return {
            'status': 'healthy',
            'timestamp': datetime.now().isoformat(),
            'model_loaded': model_service.model is not None
        }, 200

# Add resources to API
api.add_resource(PredictResource, '/predict')
api.add_resource(BatchPredictResource, '/batch_predict')
api.add_resource(ModelInfoResource, '/model_info')
api.add_resource(HealthResource, '/health')

def load_latest_model():
    """Load the latest model from the models directory"""
    models_dir = './models'
    
    if not os.path.exists(models_dir):
        logger.warning(f"Models directory not found: {models_dir}")
        return False
    
    # Find latest model files
    print(os.listdir(models_dir))
    print(sys.path)
    model_files = [f for f in os.listdir(models_dir) if f.startswith('best_model_') and f.endswith('.pkl')]
    metadata_files = [f for f in os.listdir(models_dir) if f.startswith('model_metadata_') and f.endswith('.pkl')]
    
    if not model_files or not metadata_files:
        logger.warning("No model or metadata files found")
        return False
    
    # Get the latest files
    latest_model = max(model_files, key=lambda x: os.path.getctime(os.path.join(models_dir, x)))
    latest_metadata = max(metadata_files, key=lambda x: os.path.getctime(os.path.join(models_dir, x)))
    
    model_path = os.path.join(models_dir, latest_model)
    metadata_path = os.path.join(models_dir, latest_metadata)
    
    return model_service.load_model(model_path, metadata_path)

@app.route('/')
def home():
    """Home page with API documentation"""
    documentation = {
        'title': 'Debt Repayment Prediction API',
        'description': 'API for predicting loan default risk using improved Random Forest',
        'endpoints': {
            '/predict': 'POST - Single prediction',
            '/batch_predict': 'POST - Batch predictions',
            '/model_info': 'GET - Model information',
            '/health': 'GET - Health check'
        },
        'example_request': {
            'AMT_INCOME_TOTAL': 162297.0,
            'AMT_CREDIT': 406597.5,
            'AMT_ANNUITY': 24700.5,
            'AMT_GOODS_PRICE': 351000.0,
            'DAYS_BIRTH': -9461,
            'DAYS_EMPLOYED': -637,
            'CNT_CHILDREN': 0,
            'FLAG_OWN_CAR': 0,
            'FLAG_OWN_REALTY': 1
        },
        'model_loaded': model_service.model is not None
    }
    
    return jsonify(documentation)

if __name__ == '__main__':
    # Load model on startup
    if load_latest_model():
        logger.info("Model loaded successfully")
    else:
        logger.warning("No model loaded - API will return errors until model is available")
    
    # Run the app
    app.run(host='0.0.0.0', port=6202, debug=False)