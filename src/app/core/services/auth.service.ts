import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { BehaviorSubject, Observable } from 'rxjs';
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

  login(credentials: LoginUserDto): Observable<ApiResponse<AuthData>> {
    console.log('Login con API real:', this.authApiUrl);
    return this.http.post<ApiResponse<AuthData>>(`${this.authApiUrl}/auth/login`, credentials);
  }

  // Método público para actualizar el usuario actual
  updateCurrentUser(user: User): void {
    this.currentUserSubject.next(user);
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