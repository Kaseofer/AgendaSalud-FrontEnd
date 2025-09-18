// IMPORTACIONES NECESARIAS
import { Routes } from '@angular/router';
import { authGuard } from './core/guards/auth.guard';
import { roleGuard } from './core/guards/role.guard';
import { UserRole } from './core/models/auth.model';

// CONFIGURACIÓN PRINCIPAL DE RUTAS DE LA APLICACIÓN
export const routes: Routes = [
  
  // RUTA RAÍZ: Redirige automáticamente al login
  // Cuando el usuario va a "http://localhost:4200/" lo manda a "/auth/login"
  { path: '', redirectTo: '/auth/login', pathMatch: 'full' },
  
  // MÓDULO DE AUTENTICACIÓN (LOGIN, REGISTRO, ETC.)
  // LAZY LOADING: Solo carga este código cuando el usuario accede a /auth/*
  // No requiere guards porque es público (cualquiera puede intentar loguearse)
  {
    path: 'auth',
    loadChildren: () => import('./features/auth/auth.routes').then(m => m.authRoutes)
  },
  
  // MÓDULO DE ADMINISTRADOR
  // PROTEGIDO CON 2 GUARDS:
  // 1. authGuard: Verifica que el usuario esté logueado
  // 2. roleGuard: Verifica que el usuario sea Admin
  // Solo usuarios con role "Admin" pueden acceder a /admin/*
  {
    path: 'admin',
    canActivate: [authGuard, roleGuard([UserRole.ADMIN])],
    loadChildren: () => import('./features/admin/admin.routes').then(m => m.adminRoutes)
  },
  
  // MÓDULO DE PACIENTES
  // Solo usuarios con role "Patient" pueden acceder a /patient/*
  {
    path: 'patient',
    canActivate: [authGuard, roleGuard([UserRole.PATIENT])],
    loadChildren: () => import('./features/patient/patient.routes').then(m => m.patientRoutes)
  },
  
  // MÓDULO DE PROFESIONALES (MÉDICOS)
  // Solo usuarios con role "Professional" pueden acceder a /professional/*
  {
    path: 'professional',
    canActivate: [authGuard, roleGuard([UserRole.PROFESSIONAL])],
    loadChildren: () => import('./features/professional/professional.routes').then(m => m.professionalRoutes)
  },
  
  // MÓDULO DE GESTORES/SECRETARIAS
  // Solo usuarios con role "ScheduleManager" pueden acceder a /manager/*
  {
    path: 'manager',
    canActivate: [authGuard, roleGuard([UserRole.SCHEDULE_MANAGER])],
    loadChildren: () => import('./features/manager/manager.routes').then(m => m.managerRoutes)
  },
  
  // PÁGINA DE ERROR: Usuario sin permisos
  // Se muestra cuando un guard bloquea el acceso
  { path: 'unauthorized', loadComponent: () => import('./shared/components/unauthorized.component').then(c => c.UnauthorizedComponent) },
  
  // RUTA COMODÍN: Cualquier URL no definida arriba
  // Se ejecuta al final si ninguna ruta anterior coincide
  // Redirige al login como fallback de seguridad
  { path: '**', redirectTo: '/auth/login' }
];

/*
CONCEPTOS CLAVE EXPLICADOS:

1. LAZY LOADING (loadChildren):
   - No carga todo el código de una vez
   - Solo descarga el código del módulo cuando el usuario lo visita
   - Mejora la velocidad inicial de la app
   
2. GUARDS (canActivate):
   - Son "guardianes" que deciden si puedes entrar a una ruta
   - authGuard: ¿Estás logueado? Si no -> al login
   - roleGuard: ¿Tienes el rol correcto? Si no -> unauthorized
   
3. ORDEN IMPORTA:
   - Angular evalúa las rutas de arriba hacia abajo
   - La primera que coincida se ejecuta
   - Por eso '**' va al final (es la más general)

4. PATHSMATCH: 'full':
   - Para rutas vacías, debe coincidir exactamente
   - Sin esto, '' podría coincidir con cualquier ruta

5. SEPARACIÓN POR ROLES:
   - Cada tipo de usuario tiene su propio módulo
   - Facilita el mantenimiento y la seguridad
   - Cada módulo puede tener sus propias sub-rutas
*/