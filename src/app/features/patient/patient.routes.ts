import { Routes } from '@angular/router';

export const patientRoutes: Routes = [
  { 
    path: '', 
    loadComponent: () => import('../../layout/main-layout.component').then(c => c.MainLayoutComponent),
    children: [
      { path: 'dashboard', loadComponent: () => import('./components/dashboard/dashboard.component').then(c => c.PatientDashboardComponent) },
      { path: 'appointments', loadComponent: () => import('./components/appointments/appointments.component').then(c => c.PatientAppointmentsComponent) },
      { path: 'request-appointment', loadComponent: () => import('./components/request-appointment/request-appointment.component').then(c => c.PatientRequestAppointmentComponent) },
      { path: 'history', loadComponent: () => import('./components/history/history.component').then(c => c.PatientHistoryComponent) },
      { path: 'profile', loadComponent: () => import('./components/profile/profile.component').then(c => c.PatientProfileComponent) },
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
    ]
  }
];