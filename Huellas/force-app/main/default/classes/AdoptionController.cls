public with sharing class AdoptionController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAdoptionData(Id adoptionId) {
        Adopcion__c adoption = [
            SELECT Contacto__r.Name, Contacto__r.Edad__c, 
                   Mascota__r.Name, Mascota__r.Raza__c, 
                   Fecha__c, Estado__c
            FROM Adopcion__c
            WHERE Id = :adoptionId
            LIMIT 1
        ];

        return new Map<String, Object>{
            'contactName' => adoption.Contacto__r.Name,
            'contactAge' => adoption.Contacto__r.Edad__c,
            'petName' => adoption.Mascota__r.Name,
            'petBreed' => adoption.Mascota__r.Raza__c,
            'adoptionDate' => adoption.Fecha__c,
            'isAdopted' => adoption.Estado__c == 'Finalizada'
        };
    }
}
