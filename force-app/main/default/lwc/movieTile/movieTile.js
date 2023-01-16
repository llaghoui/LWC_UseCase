import { api, LightningElement } from "lwc";

import MoviePreviewLwc from 'c/moviePreviewLwc';

export default class MovieTile extends LightningElement {
    _movie;
    name;
    pictureUrl= 'https://dummyimage.com/400x300/91deff/fff.png&text=';
    category;
    recordId;
    releaseDate;

    @api
    get movie() {
        return this._movie;
    }

    set movie(value) {
        this._movie = value;
        this.name = value.Name__c;
        this.pictureUrl += value.Name__c;
        this.category = value.Category__c;
        this.releaseDate = value.ReleaseDate__c;
        this.recordId = value.Id;
    }

    handleClick() {
		MoviePreviewLwc.open({
            label: this.name,
            size: 'large',
            recordId: this.recordId,
        });
	}

}