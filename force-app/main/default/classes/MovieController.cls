public with sharing class MovieController {
    @AuraEnabled(cacheable=true)
    public static Object[] getMovies(String searchKey) {
        String whereClause = '';

        if (searchKey != null) {
            if (!String.isEmpty(searchKey)) {
                whereClause =' WHERE Name__c LIKE \'%'+ searchKey + '%\' ';
            }
        }
        try {
            Object[] movies = Database.query(
                'SELECT Id, Name__c, Name,Category__c, IsReleased__c, MaleActorsPercentage__c, FemaleActorsPercentage__c, ReleaseDate__c, Description__c FROM Movie__c ' +
                whereClause +
                ' ORDER BY Name'
            );
            return movies;
        } catch (Exception exp) {
            System.debug(exp.getMessage());
            throw new AuraHandledException(exp.getMessage());
        }
    }

    @AuraEnabled()
    public static boolean createMovieActors(String JSONMovieActors) {
        try {
            if (JSONMovieActors == null) {
              return false;  
            }

            List<MovieActor__c> listOfMovieActors = (List<MovieActor__c>) JSON.deserialize(JSONMovieActors, List<MovieActor__c>.class);
            insert listOfMovieActors;
            return true;
        } catch (Exception exp) {
            System.debug(exp.getMessage());
        
            throw new AuraHandledException(exp.getMessage());
        }
    }
}


