import { LightningElement, wire, api } from 'lwc';
import getEntregas from '@salesforce/apex/EntregasController.getEntregas';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    { label: 'Motorista', fieldName: 'NomeMotorista', type: 'text' },
    { label: 'Valor', fieldName: 'Valor_Entrega__c', type: 'currency' },
    { label: 'Estado', fieldName: 'Estado__c', type: 'text' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' }
];

export default class EntregasDoDia extends LightningElement {

    columns = COLUMNS;
    entregas = [];
    erro;
    wiredEntregasResult;

    

    @wire(getEntregas)
    wiredEntregas(result) {
    this.wiredEntregasResult = result;
        const { data, error } = result;
        if (data){
            if (data.length > 0){
                this.entregas = data.map(item => {
                    return {
                    ...item,
                    NomeMotorista: item.Motorista__r ? item.Motorista__r.Name : 'Não atríbuido'
                    };
                });
            } else {
                this.entregas = undefined
            }
            this.erro = undefined;
        } else if (error) {
            this.entregas = undefined;
            console.error('Erro ao buscar as entregas do dia:', error);
        }
    }

    @api
    atualizarEntregas(){
        refreshApex(this.wiredEntregasResult);
    }
}
