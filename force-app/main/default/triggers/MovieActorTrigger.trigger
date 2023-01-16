trigger MovieActorTrigger on MovieActor__c (after insert) {
    Set<Id> movie_ids = new set<Id>();
    Set<Id> actor_ids = new Set<Id>();
    
    for(MovieActor__c movieActor : Trigger.new) { 
        movie_ids.add(movieActor.Movie__c);
        actor_ids.add(movieActor.Actor__c);
    }

	Map<ID, Actor__c> actors = new Map<ID, Actor__c>([SELECT Id, Name__c, Number_of_movies__c FROM Actor__c WHERE Id IN :actor_ids]);
    Map<ID, Movie__c> movies = new Map<ID, Movie__c>([SELECT Id, Name__c, FemaleActorsPercentage__c, MaleActorsPercentage__c FROM Movie__c WHERE Id IN :movie_ids]);
    
    // get actor movies
    List<AggregateResult> actorMovies = new List<AggregateResult>([
          SELECT  Actor__c, Count(Movie__c) movie_count
          FROM MovieActor__c
        WHERE Actor__c IN :actor_ids
			group by Actor__c 
        ]);
    
    for(AggregateResult aggActor: actorMovies) {
        Decimal movie_count = (Decimal)aggActor.get('movie_count');
        String actor_id = (String)aggActor.get('Actor__c');
        
        Actor__c actor = actors.get(actor_id);
        actor.Number_of_movies__c = movie_count;
        
        actors.put(actor_id, actor);
    }
    
    update actors.values();
    
    // get female actress movies
	Map<Id, Movie__c> movies_female_Actress = new Map<Id, Movie__c>([
          SELECT Id, (SELECT Actor__r.Id, Actor__r.Gender__c FROM MovieActors__r where Actor__r.Gender__c = 'Female')
          FROM Movie__c  WHERE Id IN :movie_ids
        ]);

    // get male actor movies
    Map<Id, Movie__c> movies_male_Actor = new Map<Id, Movie__c>([
          SELECT Id, (SELECT Actor__r.Id, Actor__r.Gender__c FROM MovieActors__r where Actor__r.Gender__c = 'Male')
          FROM Movie__c  WHERE Id IN :movie_ids
        ]);
   
    for(String movie_id: movie_ids) {
        Movie__c movie = movies.get(movie_id);
        Decimal FemaleActress = movies_female_Actress.get(movie_id).MovieActors__r.size();
        Decimal MaleActor = movies_male_Actor.get(movie_id).MovieActors__r.size();
        movie.FemaleActorsPercentage__c = FemaleActress / (FemaleActress + MaleActor) * 100;
        movie.MaleActorsPercentage__c = MaleActor / (FemaleActress + MaleActor) * 100;
         movies.put(movie_id, movie);
    }
    
    update movies.values();
    
    for(Movie__c movie:movies.values()){
        System.debug(movie.Name__c +'female :'+ movie.FemaleActorsPercentage__c +' male: '+movie.MaleActorsPercentage__c);
    }

    System.debug('*******');
    for(Actor__c actor :actors.values()) {
     System.debug(actor.Name__c+' '+ actor.Number_of_movies__c);   
    }
}