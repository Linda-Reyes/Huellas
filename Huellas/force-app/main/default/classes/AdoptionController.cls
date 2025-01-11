public with sharing class AdoptionController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAdoptionData(Id adoptionId) {
        // Consulta los datos de adopción, contacto y mascota
        // Verifica permisos de lectura antes de realizar la consulta
        if (!Schema.sObjectType.Adopcion__c.fields.Contact__c.isAccessible()) {
            throw new AuraHandledException('No tiene permisos para acceder a los datos de adopción.');
        }
        Adopcion__c adoptionRecord = [
            SELECT 
                Contact__r.Name,
                Contact__r.Birthdate,
                Mascota__r.Name,
                Mascota__r.Raza__c,
                Fecha__c,
                Estado__c
            FROM Adopcion__c
            WHERE Id = :adoptionId
            LIMIT 1
        ];

        // Calcula la edad del contacto
        Integer contactAge = calculateAge(adoptionRecord.Contact__r.Birthdate);

        // Verifica si la adopción está finalizada
        Boolean isAdopted = adoptionRecord.Estado__c == 'Finalizada';

        // Prepara los datos para el componente LWC
        Map<String, Object> adoptionData = new Map<String, Object>();
        adoptionData.put('contactName', adoptionRecord.Contact__r.Name);
        adoptionData.put('contactAge', contactAge);
        adoptionData.put('petName', adoptionRecord.Mascota__r.Name);
        adoptionData.put('petBreed', adoptionRecord.Mascota__r.Raza__c);
        adoptionData.put('adoptionDate', adoptionRecord.Fecha__c.format());
        adoptionData.put('isAdopted', isAdopted);

        return adoptionData;
    }

    // Método auxiliar para calcular la edad
    private static Integer calculateAge(Date birthDate) {
        if (birthDate == null) {
            return null;
        }
        Date today = Date.today();
        Integer age = today.year() - birthDate.year();
        if (today.month() < birthDate.month() || 
            (today.month() == birthDate.month() && today.day() < birthDate.day())) {
            age--;
        }
        return age;
    }
}