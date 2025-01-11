import { LightningElement, api, wire } from 'lwc';
import getAdoptionData from '@salesforce/apex/AdoptionController.getAdoptionData';
import CERTIFIED_STAMP from '@salesforce/resourceUrl/CertifiedStamp'; // Importa el recurso estático

export default class AdoptionInfo extends LightningElement {
    @api recordId; // ID del registro actual
    adoptionData;
    certifiedStampUrl = CERTIFIED_STAMP; // Asigna la URL del recurso estático

    @wire(getAdoptionData, { adoptionId: '$recordId' })
    wiredAdoptionData({ error, data }) {
        if (data) {
            this.adoptionData = data;
        } else if (error) {
            console.error('Error fetching adoption data:', error);
        }
    }
}