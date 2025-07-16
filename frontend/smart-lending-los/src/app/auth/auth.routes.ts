import {Routes} from '@angular/router';
import {AuthForbidden} from './auth.forbidden';
import { AdminLoginComponent } from '../features/login/admin-login.component';
import {AuthError} from './auth.error';

export default [
  { path: 'access', component: AuthForbidden },
  { path: 'error', component: AuthError },
  { path: 'login', component: AdminLoginComponent }
] as Routes;
