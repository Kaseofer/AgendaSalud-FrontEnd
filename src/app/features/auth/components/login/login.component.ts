import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../../core/services/auth.service';
import { ApiResponse, AuthData, User } from '../../../../core/models/auth.model';



@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})

export class LoginComponent {
  private fb = inject(FormBuilder);
  private authService = inject(AuthService);

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
        next: (response: ApiResponse<AuthData>) => {
          
          console.log('Respuesta del servidor:', response);
          
          if (response.isSuccess) {
            // Guardar datos del login
            localStorage.setItem('token', response.data.token);
            localStorage.setItem('tokenExpiration', response.data.expiresAt);
            
            const user: User = {
              userId: response.data.userId,
              email: response.data.email,
              fullName: response.data.fullName,
              role: response.data.role
            };
            
            localStorage.setItem('currentUser', JSON.stringify(user));
            this.authService.updateCurrentUser(user);
            
            this.authService.redirectByRole();
          } else {
            this.errorMessage = response.message || 'Error en el login';
            this.isLoading = false;
          }
        },
        error: (error) => {
          console.error('Error en login:', error);
          if (error.status === 401) {
            this.errorMessage = 'Credenciales inválidas';
          } else if (error.status === 0) {
            this.errorMessage = 'Error de conexión. Verifique su internet.';
          } else if (error.error?.message) {
            this.errorMessage = error.error.message;
          } else {
            this.errorMessage = 'Error del servidor. Intente nuevamente.';
          }
          this.isLoading = false;
        }
      });
    } else {
      Object.keys(this.loginForm.controls).forEach(key => {
        this.loginForm.get(key)?.markAsTouched();
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