@isTest
public class VaccinationReminderBatchTest {
    @isTest
    static void testBatchExecution() {
        // Crea datos de prueba
        List<Mascota__c> mascotas = new List<Mascota__c>();
        for (Integer i = 0; i < 5; i++) {
            mascotas.add(new Mascota__c(
                Name = 'Mascota ' + i,
                Needs_Vaccination__c = true,
                Fecha_de_la_ultima_vacunacion__c = Date.today().addMonths(-12),
                Fecha_de_la_proxima_vacunacion__c = Date.today().addMonths(1)
            ));
        }
        insert mascotas;

        // Ejecuta el batch
        Test.startTest();
        VaccinationReminderBatch batch = new VaccinationReminderBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        // Verifica que las tareas se hayan creado
        List<Task> tasks = [SELECT Id, Subject, WhatId, Description FROM Task WHERE Subject = 'Recordatorio de vacunación'];
        System.assertEquals(5, tasks.size(), 'Se deben haber creado 5 tareas de recordatorio de vacunación.');

        // Verifica que las descripciones de las tareas sean correctas
        for (Task task : tasks) {
            System.assert(task.Description.contains('necesita vacunación'), 'La descripción de la tarea debe contener "necesita vacunación".');
            System.assert(task.Description.contains('Fecha de la última vacunación'), 'La descripción de la tarea debe contener "Fecha de la última vacunación".');
            System.assert(task.Description.contains('Fecha de la próxima vacunación'), 'La descripción de la tarea debe contener "Fecha de la próxima vacunación".');
        }
    }
}