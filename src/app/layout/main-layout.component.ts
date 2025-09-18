import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { 
  Router, 
  RouterOutlet, 
  NavigationEnd, 
  RouterLink,      // <- DIRECTIVA: Convierte elementos en enlaces de navegación SPA
  RouterLinkActive // <- DIRECTIVA: Agrega clases CSS cuando la ruta está activa
} from '@angular/router';
import { AuthService } from '../core/services/auth.service';
import { UserRole } from '../core/models/auth.model';
import { filter } from 'rxjs';


  // IMPORTS OBLIGATORIOS EN STANDALONE COMPONENTS:
  // - CommonModule: *ngFor, *ngIf, pipes básicos
  // - RouterOutlet: <router-outlet> donde se renderizan las rutas hijas
  // - RouterLink: [routerLink] para navegación SPA
  // - RouterLinkActive: routerLinkActive para clases CSS dinámicas

@Component({
  selector: 'app-main-layout',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './main-layout.component.html',
  styleUrl: './main-layout.component.css'
})

export class MainLayoutComponent implements OnInit {
  private authService = inject(AuthService);
  private router = inject(Router);

  currentUser = this.authService.getCurrentUser();
  currentPageTitle = 'Dashboard';
  currentPageDescription = 'Resumen general del sistema';

  ngOnInit() {
    // Escuchar cambios de ruta para actualizar títulos
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe((event: NavigationEnd) => {
      this.updatePageTitle(event.url);
    });
    
    // Escuchar cambios del usuario autenticado
    this.authService.currentUser$.subscribe(user => {
      this.currentUser = user;
    });
  }

  get navigationItems() {
    const role = this.currentUser?.role;
    
     // RETORNA ARRAY DE OBJETOS para el *ngFor en el template
    // Cada objeto tiene: label (texto), route (URL), icon (clase CSS)
    switch (role) {
      case UserRole.ADMIN:
        return [
          { label: 'Dashboard', route: '/admin/dashboard', icon: 'fas fa-tachometer-alt' },
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

  updatePageTitle(url: string): void {
       // DICCIONARIO de títulos por ruta
    const pageTitles: { [key: string]: { title: string; description: string } } = {
      // Admin
      '/admin/dashboard': { title: 'Panel de Administración', description: 'Gestión general del sistema' },
      '/admin/users': { title: 'Gestión de Usuarios', description: 'Administrar usuarios del sistema' },
      '/admin/system': { title: 'Configuración del Sistema', description: 'Parámetros y configuraciones' },
      '/admin/settings': { title: 'Configuración', description: 'Ajustes generales' },
      
      // Patient
      '/patient/dashboard': { title: 'Mi Panel', description: 'Resumen de mi actividad médica' },
      '/patient/request-appointment': { title: 'Solicitar Turno', description: 'Reservar nueva cita médica' },
      '/patient/appointments': { title: 'Mis Turnos', description: 'Citas programadas y pendientes' },
      '/patient/history': { title: 'Mi Historial', description: 'Consultas anteriores y resultados' },
      '/patient/profile': { title: 'Mi Perfil', description: 'Información personal y configuración' },
      
      // Professional
      '/professional/dashboard': { title: 'Panel Profesional', description: 'Resumen de actividad clínica' },
      '/professional/schedule': { title: 'Mi Agenda', description: 'Calendario de citas y consultas' },
      '/professional/patients': { title: 'Mis Pacientes', description: 'Lista de pacientes atendidos' },
      '/professional/availability': { title: 'Mi Disponibilidad', description: 'Configurar horarios de atención' },
      '/professional/profile': { title: 'Mi Perfil Profesional', description: 'Datos profesionales y especialidades' },
      
      // Manager
      '/manager/dashboard': { title: 'Gestión de Agenda', description: 'Panel de control administrativo' },
      '/manager/appointments': { title: 'Gestión de Turnos', description: 'Administrar todas las citas' },
      '/manager/professionals': { title: 'Gestión de Profesionales', description: 'Administrar médicos y especialistas' },
      '/manager/patients': { title: 'Gestión de Pacientes', description: 'Administrar registro de pacientes' },
      '/manager/schedules': { title: 'Gestión de Horarios', description: 'Configurar disponibilidad general' },
      '/manager/reports': { title: 'Reportes y Estadísticas', description: 'Análisis de datos y métricas' }
    };

    const pageInfo = pageTitles[url] || { title: 'Dashboard', description: 'Panel de control' };
    this.currentPageTitle = pageInfo.title;
    this.currentPageDescription = pageInfo.description;
  }

  logout(): void {
    if (confirm('¿Está seguro que desea cerrar sesión?')) {
      this.authService.logout();
    }
  }
}