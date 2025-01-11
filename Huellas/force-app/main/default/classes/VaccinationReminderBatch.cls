public class VaccinationReminderBatch implements Database.Batchable<SObject> {
    
    // Método start: define la consulta para obtener las mascotas que necesitan vacunación
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, Fecha_de_la_ultima_vacunacion__c, Fecha_de_la_proxima_vacunacion__c 
            FROM Mascota__c 
            WHERE Needs_Vaccination__c = true
        ]);
    }

    // Método execute: se ejecuta para cada lote de registros obtenidos en el método start
    public void execute(Database.BatchableContext bc, List<Mascota__c> scope) {
        List<Task> tasks = new List<Task>();

        for (Mascota__c mascota : scope) {
            String description = 'La mascota ' + mascota.Name + ' necesita vacunación.';
            if (mascota.Fecha_de_la_ultima_vacunacion__c != null) {
                description += ' Fecha de la última vacunación: ' + mascota.Fecha_de_la_ultima_vacunacion__c.format();
            }
            if (mascota.Fecha_de_la_proxima_vacunacion__c != null) {
                description += ' Fecha de la próxima vacunación: ' + mascota.Fecha_de_la_proxima_vacunacion__c.format();
            }

            Task reminderTask = new Task(
                Subject = 'Recordatorio de vacunación',
                Status = 'Not Started',
                Priority = 'High',
                WhatId = mascota.Id,
                Description = description,
                OwnerId = UserInfo.getUserId() // Asignar al administrador actual
            );
            tasks.add(reminderTask);
        }

        if (!tasks.isEmpty()) {
            try {
                insert tasks;
            } catch (DmlException e) {
                // Manejo de errores
                System.debug('Error al insertar tareas: ' + e.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        // Código para ejecutar al finalizar el batch
        System.debug('Lote completado.');
    }
}