import { Routes } from '@angular/router';



export const adminRoutes: Routes = [
  { 
    path: '', 
    loadComponent: () => import('../../layout/main-layout.component').then(c => c.MainLayoutComponent),
    children: [
      { 
        path: 'dashboard', 
        loadComponent: () => import('./components/dashboard/dashboard.component').then(c => c.AdminDashboardComponent) 
      },
      { 
        path: 'settings', 
        loadComponent: () => import('./components/settings/settings.component').then(c => c.AdminSettingsComponent) 
      },
      { 
        path: 'system', 
        loadComponent: () => import('./components/system/system.component').then(c => c.AdminSystemComponent) 
      },
      { 
        path: 'userts', 
        loadComponent: () => import('./components/users/users.component').then(c => c.AdminUsersComponent) 
      },
     
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
    ]
  }
];