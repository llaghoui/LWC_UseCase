import { api } from "lwc";
import LightningModal from 'lightning/modal';

import NewMovieModalLwc from 'c/newMovieModalLwc';
import { deleteRecord } from 'lightning/uiRecordApi';

import NAME_FIELD from '@salesforce/schema/Movie__c.Name__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';

import removeMovieActors from '@salesforce/apex/MovieController.removeMovieActors';


export default class MoviePreviewLwc extends LightningModal {
    @api recordId;
    @api objectApiName;

    pictureUrl= 'https://dummyimage.com/400x300/91deff/fff.png&text=';

    handleLoad(event) {
        let movie_name = event.detail.records[this.recordId].fields[NAME_FIELD.fieldApiName];
        this.pictureUrl += movie_name.value;
    }

    handleUpdate() {
        this.close();
        NewMovieModalLwc.open({
            movieid: this.recordId
        });
    }

    async handleDelete() {

        const result = await LightningConfirm.open({
            message: 'Are you sure you want to delete this movie!!',
            theme: 'error', 
            label: 'Remove Movie Confirmation!', 
            variant: 'header',
        });

        if (result === false) {
            return;
        }
        
        deleteRecord(this.recordId)
        .then(() => {
            removeMovieActors({ movieId: this.recordId });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Movie deleted',
                    variant: 'success'
                })
            );
            this.close();
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error deleting record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }


    handleCancel() {
        this.close('okay');
    }
}