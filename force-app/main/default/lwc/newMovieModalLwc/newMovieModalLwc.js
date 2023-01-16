import { api, track } from 'lwc';

import LightningModal from 'lightning/modal';

import createMovieActors from '@salesforce/apex/MovieController.createMovieActors';

import ACTOR_FIELD from '@salesforce/schema/MovieActor__c.Actor__c';
import MOVIE_FIELD from '@salesforce/schema/MovieActor__c.Movie__c';

export default class NewMovieModalLwc extends LightningModal {
    @api movieid;
    @api objectApiName = 'Movie__c';
    @track selectedActors = [];

    saveMovieActionSuccess(event) {
        let movieActors = [];
        this.selectedActors.forEach(actor => {
            const fields = {};
            fields[MOVIE_FIELD.fieldApiName] = event.detail.id;
            fields[ACTOR_FIELD.fieldApiName] = actor.Id;
            movieActors.push(fields);
        });
        createMovieActors({ JSONMovieActors: JSON.stringify(movieActors)});
        this.close('success');
    }

    handleAccountSelection(event){
        if (!this.selectedActors.find(item => item.Id === event.detail.Id)) {
            this.selectedActors.push(event.detail);
        }
    }

    handleRemovePill(event) {
      console.log(JSON.parse(JSON.stringify(event)));
    }
}
