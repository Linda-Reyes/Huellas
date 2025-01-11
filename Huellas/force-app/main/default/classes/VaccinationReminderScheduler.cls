public with sharing class VaccinationReminderScheduler implements Schedulable {
    public void execute(SchedulableContext context) {
        // Inicia el trabajo Batch
        Database.executeBatch(new VaccinationReminderBatch(), 200);
    }
}
