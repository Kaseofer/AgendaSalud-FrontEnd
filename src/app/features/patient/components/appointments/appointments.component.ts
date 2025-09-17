import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-patient-appointments',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="bg-white p-6 rounded-lg shadow-sm border">
      <h2 class="text-2xl font-bold text-gray-900 mb-4">Mis Turnos</h2>
      <p class="text-gray-600 mb-4">Aquí podrás ver todos tus turnos programados.</p>
      
      <div class="bg-blue-50 border-l-4 border-blue-400 p-4">
        <div class="flex">
          <div class="flex-shrink-0">
            <i class="fas fa-info-circle text-blue-400"></i>
          </div>
          <div class="ml-3">
            <p class="text-sm text-blue-700">
              Componente en desarrollo. Aquí se mostrará la lista de todos tus turnos médicos.
            </p>
          </div>
        </div>
      </div>
    </div>
  `
})
export class PatientAppointmentsComponent {}