import { Routes } from '@angular/router';

export const patientRoutes: Routes = [
  { 
    path: '', 
    loadComponent: () => import('../../layout/main-layout.component').then(c => c.MainLayoutComponent),
    children: [
      { path: 'dashboard', loadComponent: () => import('./components/dashboard/dashboard.component').then(c => c.PatientDashboardComponent) },
      { path: 'appointments', loadComponent: () => import('./components/appointments.component').then(c => c.PatientAppointmentsComponent) },
      { path: 'request-appointment', loadComponent: () => import('./components/request-appointment.component').then(c => c.RequestAppointmentComponent) },
      { path: 'history', loadComponent: () => import('./components/history.component').then(c => c.PatientHistoryComponent) },
      { path: 'profile', loadComponent: () => import('./components/profile.component').then(c => c.PatientProfileComponent) },
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
    ]
  }
];