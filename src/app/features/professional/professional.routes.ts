// IMPORTACIÓN DE TIPOS DE ANGULAR ROUTER
import { Routes } from '@angular/router';

// RUTAS ESPECÍFICAS PARA EL MÓDULO DE PROFESIONALES
export const professionalRoutes: Routes = [
  {
    // RUTA PADRE VACÍA: Punto de entrada al módulo profesional
    // Cuando accedes a /professional, carga el layout principal
    path: '',
    
    // LAZY LOADING DEL LAYOUT: Solo carga cuando se necesita
    // MainLayoutComponent contiene sidebar, header, footer, etc.
    loadComponent: () => import('../../layout/main-layout.component').then(c => c.MainLayoutComponent),
    
    // RUTAS HIJAS: Se renderizan dentro del <router-outlet> del MainLayoutComponent
    // Todas comparten el mismo layout (sidebar, header) pero cambia el contenido central
    children: [
      
      // DASHBOARD: /professional/dashboard
      // Pantalla principal con resumen de actividad del profesional
      { 
        path: 'dashboard', 
        loadComponent: () => import('./components/dashboard/dashboard.component').then(c => c.ProfessionalDashboardComponent) 
      },
      
      // AGENDA: /professional/schedule  
      // Calendario con citas programadas del profesional
      { 
        path: 'schedule', 
        loadComponent: () => import('./components/schedule/schedule.component').then(c => c.ProfessionalScheduleComponent) 
      },
      
      // PACIENTES: /professional/patients
      // Lista de pacientes atendidos por este profesional
      { 
        path: 'patients', 
        loadComponent: () => import('./components/patients/patients.component').then(c => c.ProfessionalPatientsComponent) 
      },
      
      // DISPONIBILIDAD: /professional/availability
      // Configuración de horarios y días de trabajo
      { 
        path: 'availability', 
        loadComponent: () => import('./components/availability/availability.component').then(c => c.ProfessionalAvailabilityComponent) 
      },
      
      // PERFIL: /professional/profile
      // Datos personales y profesionales del médico
      { 
        path: 'profile', 
        loadComponent: () => import('./components/profile/profile.component').then(c => c.ProfessionalProfileComponent) 
      },
      
      // RUTA POR DEFECTO: Si accedes solo a /professional (sin sub-ruta)
      // Automáticamente redirige a /professional/dashboard
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
    ]
  }
];

/*
CONCEPTOS IMPORTANTES:

1. RUTAS PADRE-HIJO (NESTED ROUTES):
   - La ruta padre (path: '') carga el layout
   - Las rutas hijas se renderizan dentro del <router-outlet> del padre
   - URL final: /professional/dashboard = padre + hijo

2. ESTRUCTURA VISUAL RESULTANTE:
   ┌─────────────────────────────────┐
   │        MainLayoutComponent      │
   │  ┌─────────┐ ┌───────────────┐  │
   │  │Sidebar  │ │ <router-outlet>│  │ <- Aquí se cargan los children
   │  │- Dash   │ │ Dashboard     │  │
   │  │- Agenda │ │ Component     │  │
   │  │- Pac.   │ │               │  │
   │  └─────────┘ └───────────────┘  │
   └─────────────────────────────────┘

3. VENTAJAS DEL LAZY LOADING:
   - Código se descarga solo cuando se necesita
   - App inicial más rápida
   - Mejor experiencia de usuario
   - Menos memoria consumida

4. CONVENCIÓN DE NOMBRES:
   - dashboard.component.ts exporta ProfessionalDashboardComponent
   - El nombre del archivo debe coincidir con el import
   - Prefijo del rol evita conflictos (ProfessionalXxx vs PatientXxx)

5. RUTA POR DEFECTO:
   - pathMatch: 'full' significa que debe coincidir exactamente con ''
   - Sin esto, podría interferir con otras rutas
*/