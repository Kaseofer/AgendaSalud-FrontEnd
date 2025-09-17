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
    if (token && !this.isTokenExpired()) {
      // Token válido - podrías validar con el servidor aquí
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