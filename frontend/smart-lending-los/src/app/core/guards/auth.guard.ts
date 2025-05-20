import {CanActivateFn, Router} from '@angular/router';
import {inject} from '@angular/core';
import {AuthService} from '../services/auth.service';

export const authGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  // If the user is logged in, allow access
  if (authService.isLoggedIn()) {
    return true;
  }

  // Otherwise, redirect to login page
  router.navigate(['/auth/login']);
  return false;
};
