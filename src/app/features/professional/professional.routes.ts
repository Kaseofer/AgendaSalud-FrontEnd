import { Routes } from '@angular/router';

export const professionalRoutes: Routes = [
  { 
    path: '', 
    loadComponent: () => import('../../layout/main-layout.component').then(c => c.MainLayoutComponent),
    children: [
      { path: 'dashboard', loadComponent: () => import('./components/dashboard.component').then(c => c.ProfessionalDashboardComponent) },
      { path: 'schedule', loadComponent: () => import('./components/schedule.component').then(c => c.ProfessionalScheduleComponent) },
      { path: 'patients', loadComponent: () => import('./components/patients.component').then(c => c.ProfessionalPatientsComponent) },
      { path: 'availability', loadComponent: () => import('./components/availability.component').then(c => c.ProfessionalAvailabilityComponent) },
      { path: 'profile', loadComponent: () => import('./components/profile.component').then(c => c.ProfessionalProfileComponent) },
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
    ]
  }
];