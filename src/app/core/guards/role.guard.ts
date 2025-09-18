import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { UserRole } from '../models/auth.model';

export const roleGuard = (allowedRoles: UserRole[]): CanActivateFn => {
  return () => {
    const authService = inject(AuthService);
    const router = inject(Router);
    const user = authService.getCurrentUser();
    
    if (user && allowedRoles.includes(user.role as UserRole)) {
      return true;
    }
    
    router.navigate(['/unauthorized']);
    return false;
  };
};