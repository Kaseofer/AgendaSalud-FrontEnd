import { Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-professional-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class ProfessionalDashboardComponent implements OnInit {
  private authService = inject(AuthService);
  
  currentUser = this.authService.getCurrentUser();
  
  // Mock data - esto vendrá de servicios reales
  stats = {
    todayAppointments: 8,
    newPatients: 3,
    hoursWorked: 6.5,
    monthlyConsultations: 156,
    weeklyStats: {
      consultationsCompleted: 42,
      uniquePatients: 38,
      hoursWorked: 32.5,
      averageRating: 4.8
    }
  };

  todaySchedule = [
    { 
      id: 1, 
      time: '09:00', 
      patient: 'Juan Pérez', 
      type: 'Control', 
      status: 'confirmado',
      duration: 30,
      notes: 'Seguimiento post-operatorio'
    },
    { 
      id: 2, 
      time: '10:00', 
      patient: 'María González', 
      type: 'Primera vez', 
      status: 'pendiente',
      duration: 45,
      notes: 'Consulta inicial - dolor de espalda'
    },
    { 
      id: 3, 
      time: '11:30', 
      patient: 'Carlos López', 
      type: 'Seguimiento', 
      status: 'confirmado',
      duration: 30,
      notes: 'Control de medicación'
    },
    { 
      id: 4, 
      time: '14:00', 
      patient: 'Ana Martínez', 
      type: 'Control', 
      status: 'completado',
      duration: 30,
      notes: 'Revisión de resultados de laboratorio'
    }
  ];

  ngOnInit() {
    console.log('Dashboard del profesional cargado para:', this.currentUser?.fullName);
    this.loadTodayStats();
  }

  loadTodayStats() {
    // Aquí cargarías los datos reales del API
    const now = new Date();
    const currentHour = now.getHours();
    
    // Actualizar estados basado en la hora actual
    this.updateAppointmentStatuses(currentHour);
  }

  updateAppointmentStatuses(currentHour: number) {
    this.todaySchedule.forEach(appointment => {
      const appointmentHour = parseInt(appointment.time.split(':')[0]);
      if (appointmentHour < currentHour && appointment.status !== 'completado') {
        // Lógica para actualizar estados pasados
      }
    });
  }

  viewPatientDetails(patientName: string) {
    console.log('Ver detalles del paciente:', patientName);
  }

  markAppointmentComplete(appointmentId: number) {
    const appointment = this.todaySchedule.find(a => a.id === appointmentId);
    if (appointment) {
      appointment.status = 'completado';
    }
  }

  rescheduleAppointment(appointmentId: number) {
    console.log('Reprogramar cita:', appointmentId);
  }

  getStatusBadgeClass(status: string): string {
    switch (status) {
      case 'confirmado': return 'bg-green-100 text-green-700';
      case 'pendiente': return 'bg-yellow-100 text-yellow-700';
      case 'completado': return 'bg-blue-100 text-blue-700';
      case 'cancelado': return 'bg-red-100 text-red-700';
      default: return 'bg-gray-100 text-gray-700';
    }
  }

  getTypeIcon(type: string): string {
    switch (type) {
      case 'Primera vez': return 'fas fa-user-plus';
      case 'Control': return 'fas fa-stethoscope';
      case 'Seguimiento': return 'fas fa-clipboard-check';
      case 'Urgencia': return 'fas fa-exclamation-triangle';
      default: return 'fas fa-calendar';
    }
  }

  getCurrentTimeIndicator(): string {
    const now = new Date();
    return `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`;
  }
}