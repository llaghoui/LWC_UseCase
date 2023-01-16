
 public class MoviesBatchProcessor implements  
 Database.Batchable<sObject>, Database.Stateful {
    public integer recordCount = 0;
 
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([Select Id, ReleaseDate__c FROM Movie__c]);
    }
 
    public void execute(Database.BatchableContext BC, List<Movie__c> movies){
        for(Movie__c movie: movies) {
            movie.IsReleased__c = movie.ReleaseDate__c < date.today() ? true : false;
        }

        update movies;
        recordCount += movies.size();
    }
 
    public void finish(Database.BatchableContext BC){
        System.debug('Total movies processed: '+ recordCount);
    }
 }