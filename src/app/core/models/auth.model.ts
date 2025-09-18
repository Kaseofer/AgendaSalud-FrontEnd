// API Response wrapper
export interface ApiResponse<T> {
  isSuccess: boolean;
  message: string;
  data: T;
  errorCode?: string;
}

// User model
export interface User {
  userId: string;
  email: string;
  fullName: string;
  role: string;
}

// User roles enum - usar los valores exactos de tu backend
export enum UserRole {
  ADMIN = 'Admin',
  PATIENT = 'Patient', 
  PROFESSIONAL = 'Professional',
  SCHEDULE_MANAGER = 'ScheduleManager'
}

// Login DTO
export interface LoginUserDto {
  email: string;
  password: string;
}

// Auth response del backend
export interface AuthData {
  userId: string;
  email: string;
  fullName: string;
  role: string;
  token: string;
  expiresAt: string;
}