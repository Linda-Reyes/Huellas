@isTest
public class VaccinationReminderSchedulerTest {
    @isTest
    static void testScheduler() {
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

        // Ejecuta el trabajo schedulable
        Test.startTest();
        String jobId = System.schedule('Test Job', '0 0 0 1 1 ? 2040', new VaccinationReminderScheduler());
        Test.stopTest();

        // Verifica que las tareas se hayan creado
        List<Task> tasks = [SELECT Id, Subject, WhatId FROM Task WHERE Subject = 'Recordatorio de vacunación'];
        System.assertEquals(5, tasks.size(), 'Se deben haber creado 5 tareas de recordatorio de vacunación.');
    }
}