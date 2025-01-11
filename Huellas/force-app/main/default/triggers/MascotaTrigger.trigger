trigger MascotaTrigger on Mascota__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            MascotaTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            MascotaTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}