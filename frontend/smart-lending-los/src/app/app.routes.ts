import { Routes } from '@angular/router';
import {MainLayoutComponent} from './layouts/main-layout.component';
import {NotFoundComponent} from './layouts/notfound.component';
import { PredictComponent } from './features/loan/predict.component';
import { AdminLoginComponent } from './features/login/admin-login.component';
import { AdminDashboardComponent } from './features/dashboard/admin-dashboard.component';
import { LoanCreationComponent } from './features/loan-creation/loan-creation.component';
import { authGuard } from './core/guards/auth.guard';

export const routes: Routes = [
  {
    path: '',
    component: MainLayoutComponent,
    children: [
      { path: '', component: AdminDashboardComponent, canActivate: [authGuard] },
      { path: 'loan/predict', component: PredictComponent, canActivate: [authGuard] },
      { path: 'admin', component: AdminLoginComponent },
      { path: 'loan-creation/loan-creation', component: LoanCreationComponent, canActivate: [authGuard] }
    ]
  },
  { path: 'notfound', component: NotFoundComponent },
  { path: 'auth', loadChildren: () => import('./auth/auth.routes') },
  { path: '**', redirectTo: '/notfound' }
];
