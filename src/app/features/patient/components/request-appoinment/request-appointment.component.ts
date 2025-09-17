import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-request-appointment',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="bg-white p-6 rounded-lg shadow-sm border">
      <h2 class="text-2xl font-bold text-gray-900 mb-4">Solicitar Turno</h2>
      <p class="text-gray-600 mb-4">Formulario para solicitar un nuevo turno médico.</p>
      
      <div class="bg-green-50 border-l-4 border-green-400 p-4">
        <div class="flex">
          <div class="flex-shrink-0">
            <i class="fas fa-calendar-plus text-green-400"></i>
          </div>
          <div class="ml-3">
            <p class="text-sm text-green-700">
              Componente en desarrollo. Aquí podrás solicitar nuevos turnos médicos.
            </p>
          </div>
        </div>
      </div>
    </div>
  `
})
export class RequestAppointmentComponent {}