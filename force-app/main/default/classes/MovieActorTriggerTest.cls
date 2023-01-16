@isTest
public class MovieActorTriggerTest {

    @isTest static void TestMovieActorInsert() {
        Movie__c movie = new Movie__c(Name__c='Movie 1', Category__c='Horror', releaseDate__c= date.today());
        insert movie;
        
        Actor__c male_actor = new Actor__c(Name__c='Actor 1', Gender__c = 'Male');
        insert male_actor;
        
        Actor__c female_actor = new Actor__c(Name__c='Actress 1', Gender__c = 'Female');
        insert female_actor;
        
        Actor__c female_actor_2 = new Actor__c(Name__c='Actress 2', Gender__c = 'Female');
        insert female_actor_2;
        
        MovieActor__c m_a_1 = new MovieActor__c(Movie__c= movie.Id, Actor__c=male_actor.Id);
        insert m_a_1;
        
        MovieActor__c m_a_2 = new MovieActor__c(Movie__c= movie.Id, Actor__c=female_actor.Id);
        insert m_a_2;
        
        
        Movie__c movie_2 = new Movie__c(Name__c='Movie 2', Category__c='Adventure', releaseDate__c= date.today());
        insert movie_2;
        
        
         MovieActor__c m_a_3 = new MovieActor__c(Movie__c= movie_2.Id, Actor__c=female_actor.Id);
        insert m_a_3;
        
         MovieActor__c m_a_4 = new MovieActor__c(Movie__c= movie_2.Id, Actor__c=female_actor_2.Id);
        insert m_a_4;
        
         MovieActor__c m_a_5 = new MovieActor__c(Movie__c= movie_2.Id, Actor__c=male_actor.Id);
        insert m_a_5;

    }
}