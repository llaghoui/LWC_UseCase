import { LightningElement, api, wire, track } from "lwc";

import getMovies from '@salesforce/apex/MovieController.getMovies';

import MoviePreviewLwc from 'c/moviePreviewLwc';
import NewMovieModalLwc from 'c/newMovieModalLwc';
import { refreshApex } from '@salesforce/apex';

export default class FilterMoviesLwc extends LightningElement {
	@api recordId;
	@api objectApiName;

	movies = [];
	searchKey = '';

	@wire(getMovies, {
		searchKey: '$searchKey'
	})
	movies;

	handleSearchKeyChange(event) {
		this.searchKey = event.target.value;
	}

	showModalBox(movie) {
		MoviePreviewLwc.open({
            movie: movie,
        }).then((result) => {
			refreshApex(this.movies);
		});
	}

	addMovie() {
		NewMovieModalLwc.open().then((result) => {
			refreshApex(this.movies);
		});
	}

	

}