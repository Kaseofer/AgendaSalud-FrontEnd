import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../../core/services/auth.service';



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
      
      console.log('Enviando credenciales:', { email: credentials.email });
      
      this.authService.login(credentials).subscribe({
        next: (authData) => {
          console.log('Login exitoso:', authData);
          this.authService.redirectByRole();
        },
        error: (error) => {
          console.error('Error en login:', error);
          this.errorMessage = error.message || 'Error al iniciar sesión. Verifique sus credenciales.';
          this.isLoading = false;
        },
        complete: () => {
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