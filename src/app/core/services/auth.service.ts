import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { BehaviorSubject, Observable, map, tap, catchError, throwError } from 'rxjs';
import { environment } from '../../../environments/environment';
import { User, UserRole, LoginUserDto, AuthData, ApiResponse } from '../models/auth.model';

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
    const userJson = localStorage.getItem('currentUser');
    
    if (token && userJson && !this.isTokenExpired()) {
      const user = JSON.parse(userJson);
      this.currentUserSubject.next(user);
    }
  }

  login(credentials: LoginUserDto): Observable<AuthData> {
    console.log('Login con API real:', this.authApiUrl);
    
    return this.http.post<ApiResponse<AuthData>>(`${this.authApiUrl}/auth/login`, credentials)
      .pipe(
        map(response => {
          console.log('Respuesta del servidor:', response);
          
          if (!response.isSuccess) {
            throw new Error(response.message || 'Error en el login');
          }
          return response.data;
        }),
        tap(authData => {
          console.log('Datos de autenticación recibidos:', authData);
          
          localStorage.setItem('token', authData.token);
          localStorage.setItem('tokenExpiration', authData.expiresAt);
          
          const user: User = {
            userId: authData.userId,
            email: authData.email,
            fullName: authData.fullName,
            role: authData.role
          };
          
          localStorage.setItem('currentUser', JSON.stringify(user));
          this.currentUserSubject.next(user);
        }),
        catchError(error => {
          console.error('Error en login:', error);
          
          // Manejar diferentes tipos de errores
          if (error.status === 401) {
            return throwError(() => new Error('Credenciales inválidas'));
          } else if (error.status === 0) {
            return throwError(() => new Error('Error de conexión. Verifique su internet.'));
          } else if (error.error?.message) {
            return throwError(() => new Error(error.error.message));
          } else {
            return throwError(() => new Error('Error del servidor. Intente nuevamente.'));
          }
        })
      );
  }

  validateToken(): Observable<boolean> {
    const token = this.getToken();
    if (!token) {
      return throwError(() => new Error('No hay token'));
    }

    return this.http.get<ApiResponse<any>>(`${this.authApiUrl}/auth/validate-token`)
      .pipe(
        map(response => response.isSuccess),
        catchError(() => {
          this.logout();
          return throwError(() => new Error('Token inválido'));
        })
      );
  }

  logout(): void {
    localStorage.removeItem('token');
    localStorage.removeItem('tokenExpiration');
    localStorage.removeItem('currentUser');
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

    console.log('Redirigiendo usuario con rol:', user.role);

    // Mapear roles del backend a rutas
    switch (user.role) {
      case 'Admin':
        this.router.navigate(['/admin/dashboard']);
        break;
      case 'Patient':
        this.router.navigate(['/patient/dashboard']);
        break;
      case 'Professional':
        this.router.navigate(['/professional/dashboard']);
        break;
      case 'ScheduleManager':
        this.router.navigate(['/manager/dashboard']);
        break;
      default:
        console.warn('Rol no reconocido:', user.role);
        this.router.navigate(['/unauthorized']);
    }
  }
}