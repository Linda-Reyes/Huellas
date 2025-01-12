trigger HistorialVacunacionTrigger on historial_de_vacunacion__c (after insert) {
    Set<Id> mascotaIds = new Set<Id>();
    for (historial_de_vacunacion__c historial : Trigger.new) {
        mascotaIds.add(historial.Mascota__c);
    }

    // Consulta fuera del bucle
    Map<Id, Mascota__c> mascotasMap = new Map<Id, Mascota__c>([
        SELECT Id, Fecha_de_la_ultima_vacunacion__c 
        FROM Mascota__c 
        WHERE Id IN :mascotaIds
    ]);

    List<Mascota__c> mascotasToUpdate = new List<Mascota__c>();
    for (historial_de_vacunacion__c historial : Trigger.new) {
        Mascota__c mascota = mascotasMap.get(historial.Mascota__c);
        if (mascota != null) {
            mascota.Fecha_de_la_ultima_vacunacion__c = historial.Fecha__c;
            mascotasToUpdate.add(mascota);
        }
    }

    // Verificar permisos de actualización antes de actualizar
    if (Schema.sObjectType.Mascota__c.fields.Fecha_de_la_ultima_vacunacion__c.isUpdateable()) {
        if (!mascotasToUpdate.isEmpty()) {
            update mascotasToUpdate;
        }
    } else {
        // Manejar la falta de permisos, por ejemplo, registrar un error o lanzar una excepción
        System.debug('No se tienen permisos de actualización para el campo Fecha_de_la_ultima_vacunacion__c.');
    }
}