public with sharing class VaccinationReminderBatch implements Database.Batchable<SObject> {
    // Query para obtener mascotas con vacunación pendiente
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Name, Fecha_Ultima_Vacunacion__c, Fecha_Proxima_Vacunacion__c
            FROM Mascota__c
            WHERE Fecha_Proxima_Vacunacion__c <= TODAY
        ]);
    }

    // Procesa cada lote
    public void execute(Database.BatchableContext context, List<Mascota__c> scope) {
        List<Task> tasks = new List<Task>();

        for (Mascota__c pet : scope) {
            Task reminderTask = new Task(
                Subject = 'Recordatorio de vacunación',
                Status = 'Not Started',
                Priority = 'High',
                WhatId = pet.Id,
                Description = 'La mascota ' + pet.Name + ' necesita vacunación.',
                OwnerId = UserInfo.getUserId() // Asignar al administrador actual
            );
            tasks.add(reminderTask);
        }

        if (!tasks.isEmpty()) {
            insert tasks;
        }
    }

    // Método final opcional (si necesitas realizar acciones post-ejecución)
    public void finish(Database.BatchableContext context) {
        System.debug('Lote completado.');
    }
}
