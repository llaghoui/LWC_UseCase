public with sharing class MoviesBatchScheduler implements Schedulable{
    
    public void execute(SchedulableContext sc) {
        MoviesBatchProcessor moviesBatchProcessor = new MoviesBatchProcessor();

        Database.executeBatch(moviesBatchProcessor);
    }
}