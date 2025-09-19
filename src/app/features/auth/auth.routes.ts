import { Routes } from '@angular/router';
import { AuthLoginComponent } from './components/login/login.component';

export const authRoutes: Routes = [
  { path: 'login', component: AuthLoginComponent },
  { path: '', redirectTo: 'login', pathMatch: 'full' }
];