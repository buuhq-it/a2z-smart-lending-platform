import { Routes } from '@angular/router';
import {MainLayoutComponent} from './layouts/main-layout.component';
import {NotFoundComponent} from './layouts/notfound.component';
import {HomeComponent} from './features/home/home.component';
import { AdminLoginComponent } from './features/login/admin-login.component';
import { authGuard } from './core/guards/auth.guard';
import { AdminDashboardComponent } from './features/dashboard/admin-dashboard.component';

export const routes: Routes = [
  {
    path: '',
    component: MainLayoutComponent,
    children: [
      { path: '', component: HomeComponent, canActivate: [authGuard] },
      { path: 'admin', component: AdminLoginComponent },
      { path: 'admin/dashboard', component: AdminDashboardComponent },
      // { path: 'dashboard', component: Dashboard },
      // { path: 'pages', loadChildren: () => import('./pages/pages.routes') }
    ]
  },
  // { path: 'documentation', component: Documentation },
  { path: 'notfound', component: NotFoundComponent },
  { path: 'auth', loadChildren: () => import('./auth/auth.routes') },
  { path: '**', redirectTo: '/notfound' }
];
