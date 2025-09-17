import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../../../core/services/auth.service';

@Component({
  selector: 'app-patient-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class PatientDashboardComponent implements OnInit {
  private authService = inject(AuthService);
  
  currentUser = this.authService.getCurrentUser();
  
  // Mock data - esto vendrá de servicios reales
  stats = {
    nextAppointment: { date: '15 Nov 2024', time: '10:00', doctor: 'Dr. García', specialty: 'Cardiología' },
    pendingAppointments: 2,
    completedAppointments: 12
  };

  upcomingAppointments = [
    { id: 1, date: '15 Nov 2024', time: '10:00', doctor: 'Dr. García', specialty: 'Cardiología', status: 'confirmado' },
    { id: 2, date: '22 Nov 2024', time: '14:30', doctor: 'Dr. Rodríguez', specialty: 'Traumatología', status: 'pendiente' }
  ];

  ngOnInit() {
    // Aquí cargarías los datos reales del API
    console.log('Dashboard del paciente cargado para:', this.currentUser?.fullName);
  }

  requestNewAppointment() {
    // Navegar a solicitar turno
    console.log('Solicitar nuevo turno');
  }

  viewAppointmentDetails(appointmentId: number) {
    console.log('Ver detalles del turno:', appointmentId);
  }

  getStatusBadgeClass(status: string): string {
    switch (status) {
      case 'confirmado': return 'bg-green-100 text-green-700';
      case 'pendiente': return 'bg-yellow-100 text-yellow-700';
      case 'cancelado': return 'bg-red-100 text-red-700';
      default: return 'bg-gray-100 text-gray-700';
    }
  }
}