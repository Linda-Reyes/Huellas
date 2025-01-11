import { LightningElement, api, wire } from 'lwc';
import getAdoptionData from '@salesforce/apex/AdoptionController.getAdoptionData';

export default class AdoptionInfo extends LightningElement {
    @api recordId; // ID del registro actual
    adoptionData;

    @wire(getAdoptionData, { adoptionId: '$recordId' })
    wiredAdoptionData({ error, data }) {
        if (data) {
            this.adoptionData = data;
        } else if (error) {
            console.error('Error fetching adoption data:', error);
        }
    }
}