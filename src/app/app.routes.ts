import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth.guard';
import { roleGuard } from './core/guards/role.guard';
import { UserRole } from './core/models/auth.model';

export const routes: Routes = [
  { path: '', redirectTo: '/auth/login', pathMatch: 'full' },
  
  // Auth Module
  {
    path: 'auth',
    loadChildren: () => import('./features/auth/auth.routes').then(m => m.authRoutes)
  },
  
  // Admin Module  
  {
    path: 'admin',
    canActivate: [authGuard, roleGuard([UserRole.ADMIN])],
    loadChildren: () => import('./features/admin/admin.routes').then(m => m.adminRoutes)
  },
  
  // Patient Module
  {
    path: 'patient',
    canActivate: [authGuard, roleGuard([UserRole.PATIENT])],
    loadChildren: () => import('./features/patient/patient.routes').then(m => m.patientRoutes)
  },
  
  // Professional Module
  {
    path: 'professional',
    canActivate: [authGuard, roleGuard([UserRole.PROFESSIONAL])],
    loadChildren: () => import('./features/professional/professional.routes').then(m => m.professionalRoutes)
  },
  
  // Schedule Manager Module
  {
    path: 'manager',
    canActivate: [authGuard, roleGuard([UserRole.SCHEDULE_MANAGER])],
    loadChildren: () => import('./features/manager/manager.routes').then(m => m.managerRoutes)
  },
  
  // Error pages
  { path: 'unauthorized', loadComponent: () => import('./shared/components/unauthorized.component').then(c => c.UnauthorizedComponent) },
  { path: '**', redirectTo: '/auth/login' }
];