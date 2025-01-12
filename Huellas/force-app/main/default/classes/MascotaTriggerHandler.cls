public with sharing class MascotaTriggerHandler {
    public static void handleBeforeInsert(List<Mascota__c> newList) {
        // Verificar permisos de creación antes de insertar
        if (Schema.sObjectType.Mascota__c.fields.Fecha_de_la_proxima_vacunacion__c.isCreateable()) {
            setNextVaccinationDate(newList);
        } else {
            // Manejar la falta de permisos, por ejemplo, registrar un error o lanzar una excepción
            System.debug('No se tienen permisos de creación para el campo Fecha_de_la_proxima_vacunacion__c.');
        }
    }

    public static void handleBeforeUpdate(List<Mascota__c> newList, Map<Id, Mascota__c> oldMap) {
        List<Mascota__c> recordsToUpdate = new List<Mascota__c>();
        for (Mascota__c mascota : newList) {
            Mascota__c oldMascota = oldMap.get(mascota.Id);
            if (mascota.Fecha_de_la_ultima_vacunacion__c != oldMascota.Fecha_de_la_ultima_vacunacion__c) {
                recordsToUpdate.add(mascota);
            }
        }
        // Verificar permisos de actualización antes de actualizar
        if (Schema.sObjectType.Mascota__c.fields.Fecha_de_la_proxima_vacunacion__c.isUpdateable()) {
            setNextVaccinationDate(recordsToUpdate);
        } else {
            // Manejar la falta de permisos, por ejemplo, registrar un error o lanzar una excepción
            System.debug('No se tienen permisos de actualización para el campo Fecha_de_la_proxima_vacunacion__c.');
        }
    }

    private static void setNextVaccinationDate(List<Mascota__c> mascotas) {
        // Verificar permisos de acceso antes de consultar
        if (Schema.sObjectType.Vaccination_Frequency__mdt.isAccessible()) {
            Map<String, Integer> especieToIntervalMap = new Map<String, Integer>();
            for (Vaccination_Frequency__mdt freq : [SELECT Especie__c, Interval_in_days__c FROM Vaccination_Frequency__mdt]) {
                especieToIntervalMap.put(freq.Especie__c, Integer.valueOf(freq.Interval_in_days__c));
            }

            for (Mascota__c mascota : mascotas) {
                if (mascota.Fecha_de_la_ultima_vacunacion__c != null && especieToIntervalMap.containsKey(mascota.Especie__c)) {
                    Integer intervalo = especieToIntervalMap.get(mascota.Especie__c);
                    mascota.Fecha_de_la_proxima_vacunacion__c = mascota.Fecha_de_la_ultima_vacunacion__c.addDays(intervalo);
                }
            }
        } else {
            // Manejar la falta de permisos, por ejemplo, registrar un error o lanzar una excepción
            System.debug('No se tienen permisos de acceso para el objeto Vaccination_Frequency__mdt.');
        }
    }
}