# =====================================================
# Script PowerShell para crear estructura Angular 17
# Sistema AgendaSalud
# =====================================================

param(
    [string]$ProjectName = "agenda-salud-frontend",
    [string]$BasePath = "."
)

Write-Host "=== Creando proyecto Angular AgendaSalud ===" -ForegroundColor Green

# Verificar que Angular CLI esté instalado
try {
    ng version | Out-Null
    Write-Host "✓ Angular CLI encontrado" -ForegroundColor Green
} catch {
    Write-Host "✗ Angular CLI no encontrado. Instalando..." -ForegroundColor Yellow
    npm install -g @angular/cli@17
}

# Crear proyecto Angular
Write-Host "Creando proyecto Angular..." -ForegroundColor Yellow
ng new $ProjectName --routing=true --style=scss --skip-git=true --package-manager=npm

# Cambiar al directorio del proyecto
Set-Location "$BasePath\$ProjectName"

Write-Host "Instalando dependencias adicionales..." -ForegroundColor Yellow
# Instalar TailwindCSS
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init

# Instalar otras dependencias útiles
npm install @angular/material @angular/cdk
npm install @fortawesome/fontawesome-free
npm install rxjs

Write-Host "Creando estructura de carpetas..." -ForegroundColor Yellow

# =====================================================
# CREAR ESTRUCTURA DE CARPETAS
# =====================================================

# Core module
New-Item -ItemType Directory -Path "src\app\core" -Force
New-Item -ItemType Directory -Path "src\app\core\guards" -Force
New-Item -ItemType Directory -Path "src\app\core\interceptors" -Force
New-Item -ItemType Directory -Path "src\app\core\services" -Force
New-Item -ItemType Directory -Path "src\app\core\models" -Force

# Shared module
New-Item -ItemType Directory -Path "src\app\shared" -Force
New-Item -ItemType Directory -Path "src\app\shared\components" -Force
New-Item -ItemType Directory -Path "src\app\shared\directives" -Force
New-Item -ItemType Directory -Path "src\app\shared\pipes" -Force

# Layout
New-Item -ItemType Directory -Path "src\app\layout" -Force

# Features modules
New-Item -ItemType Directory -Path "src\app\features" -Force

# Auth module
New-Item -ItemType Directory -Path "src\app\features\auth" -Force
New-Item -ItemType Directory -Path "src\app\features\auth\components" -Force

# Admin module
New-Item -ItemType Directory -Path "src\app\features\admin" -Force
New-Item -ItemType Directory -Path "src\app\features\admin\components" -Force

# Patient module
New-Item -ItemType Directory -Path "src\app\features\patient" -Force
New-Item -ItemType Directory -Path "src\app\features\patient\components" -Force

# Professional module
New-Item -ItemType Directory -Path "src\app\features\professional" -Force
New-Item -ItemType Directory -Path "src\app\features\professional\components" -Force

# Manager module
New-Item -ItemType Directory -Path "src\app\features\manager" -Force
New-Item -ItemType Directory -Path "src\app\features\manager\components" -Force

# Appointments (shared)
New-Item -ItemType Directory -Path "src\app\features\appointments" -Force
New-Item -ItemType Directory -Path "src\app\features\appointments\components" -Force

Write-Host "Estructura de carpetas creada!" -ForegroundColor Green

# =====================================================
# CREAR ARCHIVOS BASE
# =====================================================

Write-Host "Creando archivos base..." -ForegroundColor Yellow

# Environment files
@"
export const environment = {
  production: false,
  apiUrl: 'https://localhost:7185',
  authApiUrl: 'https://localhost:5001',
  emailApiUrl: 'https://localhost:5002'
};
"@ | Out-File -FilePath "src\environments\environment.ts" -Encoding UTF8

@"
export const environment = {
  production: true,
  apiUrl: 'https://api-agenda-salud.com',
  authApiUrl: 'https://auth-agenda-salud.com',
  emailApiUrl: 'https://email-agenda-salud.com'
};
"@ | Out-File -FilePath "src\environments\environment.prod.ts" -Encoding UTF8

# Core Models
@"
// API Response wrapper
export interface ApiResponse<T> {
  isSuccess: boolean;
  message: string;
  data: T;
  errorCode?: string;
}
"@ | Out-File -FilePath "src\app\core\models\api-response.model.ts" -Encoding UTF8

@"
// Auth models
export interface User {
  userId: string;
  email: string;
  fullName: string;
  role: string;
}

export enum UserRole {
  ADMIN = 'Admin',
  PATIENT = 'Patient', 
  PROFESSIONAL = 'Professional',
  SCHEDULE_MANAGER = 'ScheduleManager'
}

export interface LoginUserDto {
  email: string;
  password: string;
}

export interface RegisterUserDto {
  email: string;
  password: string;
  fullName: string;
  roleName: string;
}

export interface AuthData {
  userId: string;
  email: string;
  fullName: string;
  role: string;
  token: string;
  expiresAt: string;
}
"@ | Out-File -FilePath "src\app\core\models\auth.model.ts" -Encoding UTF8

# Domain models (based on your swagger)
@"
// Domain models based on API
export interface AgendaCita {
  id: number;
  fecha: string;
  horaInicio: string;
  horaFin: string;
  ocupado: boolean;
  profesionalId: number;
  profesional?: Profesional;
  pacienteId: number;
  paciente?: Paciente;
  motivoCitaId: number;
  motivoCita?: MotivoCita;
  estadoCitaId: number;
  estadoCita?: EstadoCita;
  usuarioId: number;
  vencida: boolean;
}

export interface Profesional {
  id: number;
  matricula: string;
  nombre: string;
  apellido: string;
  telefono?: string;
  telefono2?: string;
  observaciones?: string;
  email?: string;
  fotoUrl?: string;
  fechaAlta: string;
  fechaBaja?: string;
  especialidadId: number;
  especialidad?: Especialidad;
  horarios?: ProfesionalHorario[];
  citas?: AgendaCita[];
  activo: boolean;
}

export interface Paciente {
  id: number;
  nombre: string;
  apellido: string;
  dni: number;
  fechaNacimiento: string;
  sexo: string;
  telefono?: string;
  email?: string;
  observaciones?: string;
  activo: boolean;
  obraSocialId?: number;
  obraSocial?: ObraSocial;
  nroAfiliado?: string;
  plan?: string;
  esPrivado: boolean;
}

export interface Especialidad {
  id: number;
  nombre: string;
  nombreCorto: string;
  descripcion: string;
  imagenUrl: string;
}

export interface ProfesionalHorario {
  id: number;
  diaSemana: DayOfWeek;
  horaInicio: string;
  horaFin: string;
  duracionTurnoMins: number;
  profesionalId: number;
}

export enum DayOfWeek {
  Domingo = 0,
  Lunes = 1,
  Martes = 2,
  Miercoles = 3,
  Jueves = 4,
  Viernes = 5,
  Sabado = 6
}

export interface MotivoCita {
  id: number;
  nombre: string;
  descripcion: string;
}

export interface EstadoCita {
  id: number;
  nombre: string;
  descripcion: string;
}

export interface ObraSocial {
  id: number;
  nombre: string;
  tipo: string;
  descripcion: string;
}

// Filter DTOs
export interface PacienteFiltro {
  nombre?: string;
  apellido?: string;
  dni?: number;
  fechaNacimientoDesde?: string;
  fechaNacimientoHasta?: string;
  sexo?: string;
  activo?: boolean;
  obraSocialId?: number;
  esPrivado?: boolean;
}

export interface ProfesionalFiltro {
  nombre?: string;
  apellido?: string;
  matricula?: string;
  especialidadId?: number;
  activo?: boolean;
}
"@ | Out-File -FilePath "src\app\core\models\domain.model.ts" -Encoding UTF8

# Auth Service
@"
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { BehaviorSubject, Observable, map, tap, catchError, throwError } from 'rxjs';
import { environment } from '../../../environments/environment';
import { User, UserRole, LoginUserDto, AuthData } from '../models/auth.model';
import { ApiResponse } from '../models/api-response.model';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private http = inject(HttpClient);
  private router = inject(Router);
  
  private currentUserSubject = new BehaviorSubject<User | null>(null);
  public currentUser$ = this.currentUserSubject.asObservable();
  
  private authApiUrl = environment.authApiUrl;

  constructor() {
    this.initializeAuth();
  }

  private initializeAuth(): void {
    const token = localStorage.getItem('token');
    if (token && !this.isTokenExpired()) {
      // TODO: Validate token with server or decode JWT
    }
  }

  login(credentials: LoginUserDto): Observable<AuthData> {
    return this.http.post<ApiResponse<AuthData>>(`${this.authApiUrl}/auth/login`, credentials)
      .pipe(
        map(response => {
          if (!response.isSuccess) {
            throw new Error(response.message || 'Error en el login');
          }
          return response.data;
        }),
        tap(authData => {
          localStorage.setItem('token', authData.token);
          localStorage.setItem('tokenExpiration', authData.expiresAt);
          const user: User = {
            userId: authData.userId,
            email: authData.email,
            fullName: authData.fullName,
            role: authData.role
          };
          this.currentUserSubject.next(user);
        }),
        catchError(error => {
          console.error('Error en login:', error);
          return throwError(() => error);
        })
      );
  }

  logout(): void {
    localStorage.removeItem('token');
    localStorage.removeItem('tokenExpiration');
    this.currentUserSubject.next(null);
    this.router.navigate(['/auth/login']);
  }

  getCurrentUser(): User | null {
    return this.currentUserSubject.value;
  }

  getToken(): string | null {
    return localStorage.getItem('token');
  }

  isAuthenticated(): boolean {
    return !!this.getToken() && !this.isTokenExpired();
  }

  isTokenExpired(): boolean {
    const expiration = localStorage.getItem('tokenExpiration');
    if (!expiration) return true;
    
    const expirationDate = new Date(expiration);
    return new Date() >= expirationDate;
  }

  hasRole(role: UserRole): boolean {
    const user = this.getCurrentUser();
    return user?.role === role;
  }

  redirectByRole(): void {
    const user = this.getCurrentUser();
    if (!user) return;

    switch (user.role) {
      case UserRole.ADMIN:
        this.router.navigate(['/admin/dashboard']);
        break;
      case UserRole.PATIENT:
        this.router.navigate(['/patient/dashboard']);
        break;
      case UserRole.PROFESSIONAL:
        this.router.navigate(['/professional/dashboard']);
        break;
      case UserRole.SCHEDULE_MANAGER:
        this.router.navigate(['/manager/dashboard']);
        break;
      default:
        this.router.navigate(['/unauthorized']);
    }
  }
}
"@ | Out-File -FilePath "src\app\core\services\auth.service.ts" -Encoding UTF8

# API Service
@"
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { environment } from '../../../environments/environment';
import { ApiResponse } from '../models/api-response.model';
import { 
  AgendaCita, Profesional, Paciente, Especialidad, 
  ProfesionalHorario, MotivoCita, EstadoCita, ObraSocial,
  PacienteFiltro, ProfesionalFiltro
} from '../models/domain.model';

@Injectable({ providedIn: 'root' })
export class AgendaSaludApiService {
  private http = inject(HttpClient);
  private apiUrl = environment.apiUrl;

  // Helper method para manejar las respuestas de la API
  private handleApiResponse<T>(response: ApiResponse<T>): T {
    if (!response.isSuccess) {
      throw new Error(response.message || 'Error en la operación');
    }
    return response.data;
  }

  // === AGENDA CITAS ===
  getAgendaCita(id: number): Observable<AgendaCita> {
    return this.http.get<ApiResponse<AgendaCita>>(`${this.apiUrl}/api/AgendaCitas/${id}`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  getAllAgendaCitas(): Observable<AgendaCita[]> {
    return this.http.get<ApiResponse<AgendaCita[]>>(`${this.apiUrl}/api/AgendaCitas/All`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  createAgendaCita(cita: AgendaCita): Observable<AgendaCita> {
    return this.http.post<ApiResponse<AgendaCita>>(`${this.apiUrl}/api/AgendaCitas/Create`, cita)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  updateAgendaCita(cita: AgendaCita): Observable<AgendaCita> {
    return this.http.put<ApiResponse<AgendaCita>>(`${this.apiUrl}/api/AgendaCitas/Update`, cita)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  deleteAgendaCita(id: number): Observable<void> {
    return this.http.delete<ApiResponse<void>>(`${this.apiUrl}/api/AgendaCitas/${id}`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  // === PACIENTES ===
  getAllPacientes(): Observable<Paciente[]> {
    return this.http.get<ApiResponse<Paciente[]>>(`${this.apiUrl}/api/Pacientes/All`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  getPaciente(id: number): Observable<Paciente> {
    return this.http.get<ApiResponse<Paciente>>(`${this.apiUrl}/api/Pacientes/${id}`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  findPacientes(filtro: PacienteFiltro): Observable<Paciente[]> {
    return this.http.post<ApiResponse<Paciente[]>>(`${this.apiUrl}/api/Pacientes/Find`, filtro)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  // === PROFESIONALES ===
  getAllProfesionales(): Observable<Profesional[]> {
    return this.http.get<ApiResponse<Profesional[]>>(`${this.apiUrl}/api/Profesional/All`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  getProfesional(id: number): Observable<Profesional> {
    return this.http.get<ApiResponse<Profesional>>(`${this.apiUrl}/api/Profesional/${id}`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  findProfesionales(filtro: ProfesionalFiltro): Observable<Profesional[]> {
    return this.http.post<ApiResponse<Profesional[]>>(`${this.apiUrl}/api/Profesional/Find`, filtro)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  // === CATÁLOGOS ===
  getAllEspecialidades(): Observable<Especialidad[]> {
    return this.http.get<ApiResponse<Especialidad[]>>(`${this.apiUrl}/api/Especialidad/All`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  getAllMotivoCitas(): Observable<MotivoCita[]> {
    return this.http.get<ApiResponse<MotivoCita[]>>(`${this.apiUrl}/api/MotivoCita/All`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  getAllEstadoCitas(): Observable<EstadoCita[]> {
    return this.http.get<ApiResponse<EstadoCita[]>>(`${this.apiUrl}/api/EstadoCita/All`)
      .pipe(map(response => this.handleApiResponse(response)));
  }

  getAllObrasSociales(): Observable<ObraSocial[]> {
    return this.http.get<ApiResponse<ObraSocial[]>>(`${this.apiUrl}/api/ObraSocial/All`)
      .pipe(map(response => this.handleApiResponse(response)));
  }
}
"@ | Out-File -FilePath "src\app\core\services\agenda-salud-api.service.ts" -Encoding UTF8

# Guards
@"
import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const authGuard: CanActivateFn = () => {
  const authService = inject(AuthService);
  const router = inject(Router);
  
  if (authService.isAuthenticated()) {
    return true;
  }
  
  router.navigate(['/auth/login']);
  return false;
};
"@ | Out-File -FilePath "src\app\core\guards\auth.guard.ts" -Encoding UTF8

@"
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
"@ | Out-File -FilePath "src\app\core\guards\role.guard.ts" -Encoding UTF8

# Auth Interceptor
@"
import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth.service';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(AuthService);
  const token = authService.getToken();
  
  if (token) {
    const authReq = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`
      }
    });
    return next(authReq);
  }
  
  return next(req);
};
"@ | Out-File -FilePath "src\app\core\interceptors\auth.interceptor.ts" -Encoding UTF8

# App Config
@"
import { ApplicationConfig, importProvidersFrom } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { provideAnimations } from '@angular/platform-browser/animations';
import { routes } from './app.routes';
import { authInterceptor } from './core/interceptors/auth.interceptor';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideHttpClient(withInterceptors([authInterceptor])),
    provideAnimations()
  ]
};
"@ | Out-File -FilePath "src\app\app.config.ts" -Encoding UTF8 -Force

# Main Routes
@"
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
"@ | Out-File -FilePath "src\app\app.routes.ts" -Encoding UTF8 -Force

# Auth Routes
@"
import { Routes } from '@angular/router';
import { LoginComponent } from './components/login.component';

export const authRoutes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: '', redirectTo: 'login', pathMatch: 'full' }
];
"@ | Out-File -FilePath "src\app\features\auth\auth.routes.ts" -Encoding UTF8

# Patient Routes
@"
import { Routes } from '@angular/router';

export const patientRoutes: Routes = [
  { 
    path: '', 
    loadComponent: () => import('../../layout/main-layout.component').then(c => c.MainLayoutComponent),
    children: [
      { path: 'dashboard', loadComponent: () => import('./components/dashboard.component').then(c => c.PatientDashboardComponent) },
      { path: 'appointments', loadComponent: () => import('./components/appointments.component').then(c => c.PatientAppointmentsComponent) },
      { path: 'request-appointment', loadComponent: () => import('./components/request-appointment.component').then(c => c.RequestAppointmentComponent) },
      { path: 'history', loadComponent: () => import('./components/history.component').then(c => c.PatientHistoryComponent) },
      { path: 'profile', loadComponent: () => import('./components/profile.component').then(c => c.PatientProfileComponent) },
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
    ]
  }
];
"@ | Out-File -FilePath "src\app\features\patient\patient.routes.ts" -Encoding UTF8

# Professional Routes
@"
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
"@ | Out-File -FilePath "src\app\features\professional\professional.routes.ts" -Encoding UTF8

# Manager Routes
@"
import { Routes } from '@angular/router';

export const managerRoutes: Routes = [
  { 
    path: '', 
    loadComponent: () => import('../../layout/main-layout.component').then(c => c.MainLayoutComponent),
    children: [
      { path: 'dashboard', loadComponent: () => import('./components/dashboard.component').then(c => c.ManagerDashboardComponent) },
      { path: 'appointments', loadComponent: () => import('./components/appointments.component').then(c => c.ManagerAppointmentsComponent) },
      { path: 'professionals', loadComponent: () => import('./components/professionals.component').then(c => c.ManagerProfessionalsComponent) },
      { path: 'patients', loadComponent: () => import('./components/patients.component').then(c => c.ManagerPatientsComponent) },
      { path: 'schedules', loadComponent: () => import('./components/schedules.component').then(c => c.ManagerSchedulesComponent) },
      { path: 'reports', loadComponent: () => import('./components/reports.component').then(c => c.ManagerReportsComponent) },
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
    ]
  }
];
"@ | Out-File -FilePath "src\app\features\manager\manager.routes.ts" -Encoding UTF8

# Admin Routes
@"
import { Routes } from '@angular/router';

export const adminRoutes: Routes = [
  { 
    path: '', 
    loadComponent: () => import('../../layout/main-layout.component').then(c => c.MainLayoutComponent),
    children: [
      { path: 'dashboard', loadComponent: () => import('./components/dashboard.component').then(c => c.AdminDashboardComponent) },
      { path: 'users', loadComponent: () => import('./components/users.component').then(c => c.AdminUsersComponent) },
      { path: 'system', loadComponent: () => import('./components/system.component').then(c => c.AdminSystemComponent) },
      { path: 'settings', loadComponent: () => import('./components/settings.component').then(c => c.AdminSettingsComponent) },
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
    ]
  }
];
"@ | Out-File -FilePath "src\app\features\admin\admin.routes.ts" -Encoding UTF8

# Basic Login Component
@"
import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  template: \`
    <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 py-12 px-4">
      <div class="max-w-md w-full space-y-8">
        <div class="bg-white rounded-lg shadow-xl p-8">
          <div class="text-center mb-8">
            <h2 class="text-3xl font-extrabold text-gray-900">AgendaSalud</h2>
            <p class="mt-2 text-sm text-gray-600">Sistema de Gestión de Turnos</p>
          </div>
          
          <form [formGroup]="loginForm" (ngSubmit)="onSubmit()" class="space-y-6">
            <div>
              <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
              <input
                id="email"
                type="email"
                formControlName="email"
                class="mt-1 w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                placeholder="tu@email.com">
            </div>
            
            <div>
              <label for="password" class="block text-sm font-medium text-gray-700">Contraseña</label>
              <input
                id="password"
                type="password"
                formControlName="password"
                class="mt-1 w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                placeholder="••••••••">
            </div>

            <div *ngIf="errorMessage" class="text-red-600 text-sm text-center">
              {{ errorMessage }}
            </div>

            <button
              type="submit"
              [disabled]="loginForm.invalid || isLoading"
              class="w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50">
              {{ isLoading ? 'Ingresando...' : 'Iniciar Sesión' }}
            </button>

            <!-- Demo buttons -->
            <div class="mt-4 grid grid-cols-2 gap-2">
              <button type="button" (click)="loginAsDemo('patient@demo.com')"
                class="px-3 py-2 text-xs bg-green-100 text-green-700 rounded hover:bg-green-200">
                Paciente Demo
              </button>
              <button type="button" (click)="loginAsDemo('professional@demo.com')"
                class="px-3 py-2 text-xs bg-blue-100 text-blue-700 rounded hover:bg-blue-200">
                Profesional Demo
              </button>
              <button type="button" (click)="loginAsDemo('manager@demo.com')"
                class="px-3 py-2 text-xs bg-purple-100 text-purple-700 rounded hover:bg-purple-200">
                Manager Demo
              </button>
              <button type="button" (click)="loginAsDemo('admin@demo.com')"
                class="px-3 py-2 text-xs bg-red-100 text-red-700 rounded hover:bg-red-200">
                Admin Demo
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  \`
})
export class LoginComponent {
  private fb = inject(FormBuilder);
  private authService = inject(AuthService);
  private router = inject(Router);

  isLoading = false;
  errorMessage = '';

  loginForm = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(6)]]
  });

  onSubmit(): void {
    if (this.loginForm.valid) {
      this.isLoading = true;
      this.errorMessage = '';
      
      const credentials = this.loginForm.value as { email: string; password: string };
      
      this.authService.login(credentials).subscribe({
        next: (authData) => {
          this.authService.redirectByRole();
        },
        error: (error) => {
          this.errorMessage = error.message || 'Error al iniciar sesión';
          this.isLoading = false;
        }
      });
    }
  }

  loginAsDemo(email: string): void {
    this.loginForm.patchValue({
      email: email,
      password: 'demo123'
    });
  }
}
"@ | Out-File -FilePath "src\app\features\auth\components\login.component.ts" -Encoding UTF8

# Main Layout Component
@"
import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterOutlet, NavigationEnd } from '@angular/router';
import { AuthService } from '../core/services/auth.service';
import { UserRole } from '../core/models/auth.model';
import { filter } from 'rxjs';

@Component({
  selector: 'app-main-layout',
  standalone: true,
  imports: [CommonModule, RouterOutlet],
  template: \`
    <div class="flex h-screen bg-gray-50">
      <!-- Sidebar -->
      <nav class="w-64 bg-white shadow-lg border-r">
        <div class="p-6 border-b">
          <h1 class="text-xl font-bold text-gray-800">AgendaSalud</h1>
        </div>
        
        <div class="py-6">
          <nav class="space-y-1 px-4">
            <a 
              *ngFor="let item of navigationItems" 
              [routerLink]="item.route"
              routerLinkActive="bg-blue-100 text-blue-700"
              class="group flex items-center px-3 py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100">
              <i [class]="item.icon" class="mr-3"></i>
              {{ item.label }}
            </a>
          </nav>
        </div>
        
        <div class="absolute bottom-0 left-0 right-0 p-4 border-t">
          <div class="flex items-center mb-3">
            <div class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center">
              <span class="text-white text-xs font-medium">{{ getUserInitials() }}</span>
            </div>
            <div class="ml-3">
              <p class="text-sm font-medium text-gray-700">{{ currentUser?.fullName }}</p>
              <p class="text-xs text-gray-500">{{ getRoleDisplayName() }}</p>
            </div>
          </div>
          <button 
            (click)="logout()"
            class="w-full flex items-center px-3 py-2 text-sm text-red-600 hover:bg-red-50 rounded-md">
            <i class="fas fa-sign-out-alt mr-3"></i>
            Cerrar Sesión
          </button>
        </div>
      </nav>

      <!-- Main Content -->
      <div class="flex-1 flex flex-col overflow-hidden">
        <header class="bg-white shadow-sm border-b px-6 py-4">
          <div class="flex justify-between items-center">
            <h2 class="text-2xl font-semibold text-gray-800">{{ currentPageTitle }}</h2>
          </div>
        </header>

        <main class="flex-1 p-6 overflow-auto">
          <router-outlet></router-outlet>
        </main>
      </div>
    </div>
  \`
})
export class MainLayoutComponent implements OnInit {
  private authService = inject(AuthService);
  private router = inject(Router);

  currentUser = this.authService.getCurrentUser();
  currentPageTitle = 'Dashboard';

  ngOnInit() {
    this.authService.currentUser$.subscribe(user => {
      this.currentUser = user;
    });
  }

  get navigationItems() {
    const role = this.currentUser?.role;
    
    switch (role) {
      case UserRole.ADMIN:
        return [
          { label: 'Dashboard', route: '/admin/dashboard', icon: 'fas fa-home' },
          { label: 'Usuarios', route: '/admin/users', icon: 'fas fa-users' },
          { label: 'Sistema', route: '/admin/system', icon: 'fas fa-cogs' },
          { label: 'Configuración', route: '/admin/settings', icon: 'fas fa-sliders-h' }
        ];
      
      case UserRole.PATIENT:
        return [
          { label: 'Dashboard', route: '/patient/dashboard', icon: 'fas fa-home' },
          { label: 'Solicitar Turno', route: '/patient/request-appointment', icon: 'fas fa-plus-circle' },
          { label: 'Mis Turnos', route: '/patient/appointments', icon: 'fas fa-calendar-check' },
          { label: 'Historial', route: '/patient/history', icon: 'fas fa-history' },
          { label: 'Mi Perfil', route: '/patient/profile', icon: 'fas fa-user-circle' }
        ];
      
      case UserRole.PROFESSIONAL:
        return [
          { label: 'Dashboard', route: '/professional/dashboard', icon: 'fas fa-home' },
          { label: 'Mi Agenda', route: '/professional/schedule', icon: 'fas fa-calendar-alt' },
          { label: 'Pacientes', route: '/professional/patients', icon: 'fas fa-users' },
          { label: 'Disponibilidad', route: '/professional/availability', icon: 'fas fa-clock' },
          { label: 'Mi Perfil', route: '/professional/profile', icon: 'fas fa-user-md' }
        ];
      
      case UserRole.SCHEDULE_MANAGER:
        return [
          { label: 'Dashboard', route: '/manager/dashboard', icon: 'fas fa-home' },
          { label: 'Gestión Turnos', route: '/manager/appointments', icon: 'fas fa-calendar-alt' },
          { label: 'Profesionales', route: '/manager/professionals', icon: 'fas fa-user-md' },
          { label: 'Pacientes', route: '/manager/patients', icon: 'fas fa-users' },
          { label: 'Horarios', route: '/manager/schedules', icon: 'fas fa-clock' },
          { label: 'Reportes', route: '/manager/reports', icon: 'fas fa-chart-bar' }
        ];
      
      default:
        return [];
    }
  }

  getUserInitials(): string {
    if (!this.currentUser?.fullName) return '??';
    return this.currentUser.fullName
      .split(' ')
      .map(name => name.charAt(0))
      .join('')
      .toUpperCase()
      .slice(0, 2);
  }

  getRoleDisplayName(): string {
    switch (this.currentUser?.role) {
      case UserRole.ADMIN: return 'Administrador';
      case UserRole.PATIENT: return 'Paciente';
      case UserRole.PROFESSIONAL: return 'Profesional';
      case UserRole.SCHEDULE_MANAGER: return 'Gestor de Agenda';
      default: return 'Usuario';
    }
  }

  logout(): void {
    if (confirm('¿Está seguro que desea cerrar sesión?')) {
      this.authService.logout();
    }
  }
}
"@ | Out-File -FilePath "src\app\layout\main-layout.component.ts" -Encoding UTF8

# Crear componentes básicos de dashboard para cada rol
# Patient Dashboard
@"
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-patient-dashboard',
  standalone: true,
  imports: [CommonModule],
  template: \`
    <div class="space-y-6">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div class="bg-white p-6 rounded-lg shadow-sm border">
          <h3 class="text-lg font-semibold text-gray-900">Próximo Turno</h3>
          <p class="text-2xl font-bold text-blue-600 mt-2">15 Nov</p>
          <p class="text-sm text-gray-600">10:00 - Dr. García</p>
        </div>
        
        <div class="bg-white p-6 rounded-lg shadow-sm border">
          <h3 class="text-lg font-semibold text-gray-900">Turnos Pendientes</h3>
          <p class="text-2xl font-bold text-green-600 mt-2">2</p>
          <p class="text-sm text-gray-600">Este mes</p>
        </div>
        
        <div class="bg-white p-6 rounded-lg shadow-sm border">
          <h3 class="text-lg font-semibold text-gray-900">Consultas Realizadas</h3>
          <p class="text-2xl font-bold text-purple-600 mt-2">12</p>
          <p class="text-sm text-gray-600">Este año</p>
        </div>
      </div>

      <div class="bg-white p-6 rounded-lg shadow-sm border">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Acciones Rápidas</h3>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          <button class="p-4 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200">
            <i class="fas fa-plus-circle text-2xl mb-2"></i>
            <p class="text-sm font-medium">Solicitar Turno</p>
          </button>
          
          <button class="p-4 bg-green-100 text-green-700 rounded-lg hover:bg-green-200">
            <i class="fas fa-calendar-check text-2xl mb-2"></i>
            <p class="text-sm font-medium">Ver Turnos</p>
          </button>
          
          <button class="p-4 bg-purple-100 text-purple-700 rounded-lg hover:bg-purple-200">
            <i class="fas fa-history text-2xl mb-2"></i>
            <p class="text-sm font-medium">Historial</p>
          </button>
          
          <button class="p-4 bg-orange-100 text-orange-700 rounded-lg hover:bg-orange-200">
            <i class="fas fa-user-circle text-2xl mb-2"></i>
            <p class="text-sm font-medium">Mi Perfil</p>
          </button>
        </div>
      </div>
    </div>
  \`
})
export class PatientDashboardComponent {}
"@ | Out-File -FilePath "src\app\features\patient\components\dashboard.component.ts" -Encoding UTF8

# Crear componentes placeholder para otros módulos
$dashboardComponents = @(
    @{ path = "src\app\features\professional\components\dashboard.component.ts"; name = "ProfessionalDashboardComponent"; title = "Dashboard Profesional" },
    @{ path = "src\app\features\manager\components\dashboard.component.ts"; name = "ManagerDashboardComponent"; title = "Dashboard Manager" },
    @{ path = "src\app\features\admin\components\dashboard.component.ts"; name = "AdminDashboardComponent"; title = "Dashboard Admin" }
)

foreach ($component in $dashboardComponents) {
@"
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-$($component.name.ToLower().Replace('component', ''))',
  standalone: true,
  imports: [CommonModule],
  template: \`
    <div class="bg-white p-6 rounded-lg shadow-sm border">
      <h2 class="text-2xl font-bold text-gray-900 mb-4">${($component.title)}</h2>
      <p class="text-gray-600">Contenido del dashboard en desarrollo...</p>
      
      <div class="mt-6 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <div class="bg-blue-50 p-4 rounded-lg">
          <h3 class="font-semibold text-blue-900">Estadística 1</h3>
          <p class="text-2xl font-bold text-blue-600">0</p>
        </div>
        
        <div class="bg-green-50 p-4 rounded-lg">
          <h3 class="font-semibold text-green-900">Estadística 2</h3>
          <p class="text-2xl font-bold text-green-600">0</p>
        </div>
        
        <div class="bg-purple-50 p-4 rounded-lg">
          <h3 class="font-semibold text-purple-900">Estadística 3</h3>
          <p class="text-2xl font-bold text-purple-600">0</p>
        </div>
      </div>
    </div>
  \`
})
export class $($component.name) {}
"@ | Out-File -FilePath $component.path -Encoding UTF8
}

# Crear componentes placeholder para todas las rutas
$placeholderComponents = @(
    # Patient components
    @{ path = "src\app\features\patient\components\appointments.component.ts"; name = "PatientAppointmentsComponent"; title = "Mis Turnos" },
    @{ path = "src\app\features\patient\components\request-appointment.component.ts"; name = "RequestAppointmentComponent"; title = "Solicitar Turno" },
    @{ path = "src\app\features\patient\components\history.component.ts"; name = "PatientHistoryComponent"; title = "Mi Historial" },
    @{ path = "src\app\features\patient\components\profile.component.ts"; name = "PatientProfileComponent"; title = "Mi Perfil" },
    
    # Professional components
    @{ path = "src\app\features\professional\components\schedule.component.ts"; name = "ProfessionalScheduleComponent"; title = "Mi Agenda" },
    @{ path = "src\app\features\professional\components\patients.component.ts"; name = "ProfessionalPatientsComponent"; title = "Mis Pacientes" },
    @{ path = "src\app\features\professional\components\availability.component.ts"; name = "ProfessionalAvailabilityComponent"; title = "Mi Disponibilidad" },
    @{ path = "src\app\features\professional\components\profile.component.ts"; name = "ProfessionalProfileComponent"; title = "Mi Perfil Profesional" },
    
    # Manager components
    @{ path = "src\app\features\manager\components\appointments.component.ts"; name = "ManagerAppointmentsComponent"; title = "Gestión de Turnos" },
    @{ path = "src\app\features\manager\components\professionals.component.ts"; name = "ManagerProfessionalsComponent"; title = "Gestión de Profesionales" },
    @{ path = "src\app\features\manager\components\patients.component.ts"; name = "ManagerPatientsComponent"; title = "Gestión de Pacientes" },
    @{ path = "src\app\features\manager\components\schedules.component.ts"; name = "ManagerSchedulesComponent"; title = "Gestión de Horarios" },
    @{ path = "src\app\features\manager\components\reports.component.ts"; name = "ManagerReportsComponent"; title = "Reportes y Estadísticas" },
    
    # Admin components
    @{ path = "src\app\features\admin\components\users.component.ts"; name = "AdminUsersComponent"; title = "Gestión de Usuarios" },
    @{ path = "src\app\features\admin\components\system.component.ts"; name = "AdminSystemComponent"; title = "Configuración del Sistema" },
    @{ path = "src\app\features\admin\components\settings.component.ts"; name = "AdminSettingsComponent"; title = "Configuración General" }
)

foreach ($component in $placeholderComponents) {
@"
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-$($component.name.ToLower().Replace('component', ''))',
  standalone: true,
  imports: [CommonModule],
  template: \`
    <div class="bg-white p-6 rounded-lg shadow-sm border">
      <h2 class="text-2xl font-bold text-gray-900 mb-4">${($component.title)}</h2>
      <p class="text-gray-600 mb-4">Componente en desarrollo...</p>
      
      <div class="bg-blue-50 border-l-4 border-blue-400 p-4">
        <div class="flex">
          <div class="flex-shrink-0">
            <i class="fas fa-info-circle text-blue-400"></i>
          </div>
          <div class="ml-3">
            <p class="text-sm text-blue-700">
              Este componente será implementado en las siguientes iteraciones del desarrollo.
            </p>
          </div>
        </div>
      </div>
    </div>
  \`
})
export class $($component.name) {}
"@ | Out-File -FilePath $component.path -Encoding UTF8
}

# Componente Unauthorized
@"
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-unauthorized',
  standalone: true,
  imports: [CommonModule],
  template: \`
    <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4">
      <div class="max-w-md w-full text-center">
        <div class="bg-white rounded-lg shadow-xl p-8">
          <div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <i class="fas fa-exclamation-triangle text-red-600 text-2xl"></i>
          </div>
          <h2 class="text-2xl font-bold text-gray-900 mb-2">Acceso No Autorizado</h2>
          <p class="text-gray-600 mb-6">No tienes permisos para acceder a esta página.</p>
          <button 
            (click)="goBack()"
            class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
            Volver
          </button>
        </div>
      </div>
    </div>
  \`
})
export class UnauthorizedComponent {
  constructor(private router: Router) {}

  goBack() {
    this.router.navigate(['/auth/login']);
  }
}
"@ | Out-File -FilePath "src\app\shared\components\unauthorized.component.ts" -Encoding UTF8

# Configurar TailwindCSS
@"
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
"@ | Out-File -FilePath "tailwind.config.js" -Encoding UTF8 -Force

# Actualizar styles.scss
@"
@tailwind base;
@tailwind components;
@tailwind utilities;

/* FontAwesome */
@import '~@fortawesome/fontawesome-free/css/all.min.css';

/* Custom styles */
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  margin: 0;
  padding: 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

/* Loading spinner */
.spinner {
  border: 2px solid #f3f3f3;
  border-top: 2px solid #3498db;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
"@ | Out-File -FilePath "src\styles.scss" -Encoding UTF8 -Force

# Actualizar angular.json para incluir FontAwesome
Write-Host "Actualizando configuración de Angular..." -ForegroundColor Yellow

# Crear README con instrucciones
@"
# AgendaSalud Frontend

Sistema de gestión de turnos médicos desarrollado en Angular 17.

## Instalación

1. Asegúrate de tener Node.js instalado (versión 18 o superior)
2. Instala Angular CLI: \`npm install -g @angular/cli@17\`
3. Instala las dependencias: \`npm install\`

## Configuración

1. Actualiza las URLs de los servicios en \`src/environments/environment.ts\`:
   - \`apiUrl\`: URL de tu API principal (AgendaSaludApp.Api)
   - \`authApiUrl\`: URL de tu servicio de autenticación
   - \`emailApiUrl\`: URL de tu servicio de email

2. Para producción, actualiza \`src/environments/environment.prod.ts\`

## Desarrollo

Ejecuta \`ng serve\` para iniciar el servidor de desarrollo.
Navega a \`http://localhost:4200/\`.

## Estructura del Proyecto

- \`src/app/core/\` - Servicios principales, guardas, interceptores y modelos
- \`src/app/shared/\` - Componentes reutilizables
- \`src/app/features/\` - Módulos por funcionalidad
- \`src/app/layout/\` - Componentes de layout

## Roles y Rutas

- **Admin**: \`/admin/*\`
- **Patient**: \`/patient/*\`
- **Professional**: \`/professional/*\`
- **ScheduleManager**: \`/manager/*\`

## Usuarios Demo

Para desarrollo, puedes usar estos usuarios:
- \`admin@demo.com\` / \`demo123\`
- \`patient@demo.com\` / \`demo123\`
- \`professional@demo.com\` / \`demo123\`
- \`manager@demo.com\` / \`demo123\`

## Próximos Pasos

1. Implementar los componentes faltantes
2. Agregar validaciones de formularios
3. Implementar manejo de errores global
4. Agregar tests unitarios
5. Optimizar para producción
"@ | Out-File -FilePath "README.md" -Encoding UTF8

Write-Host "✓ Proyecto Angular creado exitosamente!" -ForegroundColor Green
Write-Host ""
Write-Host "=== RESUMEN ===" -ForegroundColor Cyan
Write-Host "📁 Proyecto creado en: $ProjectName" -ForegroundColor White
Write-Host "🔧 Estructura de carpetas completa" -ForegroundColor White
Write-Host "📄 Archivos base creados" -ForegroundColor White
Write-Host "🎨 TailwindCSS configurado" -ForegroundColor White
Write-Host "🔒 Sistema de autenticación implementado" -ForegroundColor White
Write-Host "🛣️  Routing modular configurado" -ForegroundColor White
Write-Host ""
Write-Host "=== SIGUIENTE PASO ===" -ForegroundColor Yellow
Write-Host "1. cd $ProjectName" -ForegroundColor White
Write-Host "2. ng serve" -ForegroundColor White
Write-Host "3. Abrir http://localhost:4200" -ForegroundColor White
Write-Host ""
Write-Host "=== NOTAS IMPORTANTES ===" -ForegroundColor Red
Write-Host "• Actualiza las URLs en environment.ts con tus servicios reales" -ForegroundColor White
Write-Host "• Los componentes están creados como placeholders - necesitan implementación" -ForegroundColor White
Write-Host "• Revisa el README.md para más información" -ForegroundColor White