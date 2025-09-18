import { Routes } from '@angular/router';

export const managerRoutes: Routes = [
  { 
    path: '', 
    loadComponent: () => import('../../layout/main-layout.component').then(c => c.MainLayoutComponent),
    children: [
      { 
        path: 'dashboard', 
        loadComponent: () => import('./components/dashboard/dashboard.component').then(c => c.ManagerDashboardComponent) 
      },
      { 
        path: 'appointments', 
        loadComponent: () => import('./components/appointments/appointments.component').then(c => c.ManagerAppointmentsComponent) 
      },
      { 
        path: 'professionals', 
        loadComponent: () => import('./components/professionals/professionals.component').then(c => c.ManagerProfessionalsComponent) 
      },
      { 
        path: 'patients', 
        loadComponent: () => import('./components/patients/patients.component').then(c => c.ManagerPatientsComponent) 
      },
      { 
        path: 'schedules', 
        loadComponent: () => import('./components/schedules/schedules.component').then(c => c.ManagerSchedulesComponent) 
      },
      { 
        path: 'reports', 
        loadComponent: () => import('./components/reports/reports.component').then(c => c.ManagerReportsComponent) 
      },
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
    ]
  }
];