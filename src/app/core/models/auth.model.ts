export interface ApiResponse<T> {
  isSuccess: boolean;
  message: string;
  data: T;
  errorCode?: string;
}

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

export interface AuthData {
  userId: string;
  email: string;
  fullName: string;
  role: string;
  token: string;
  expiresAt: string;
}