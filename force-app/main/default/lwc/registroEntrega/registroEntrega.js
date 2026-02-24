import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import salvar from '@salesforce/apex/EntregasController.salvar';
import preencherCep from '@salesforce/apex/EntregasController.preencherCep';

export default class RegistroEntrega extends LightningElement {
    @api atualizarEntregas;
    
    limparForm(){
        const fields = this.template.querySelectorAll('lightning-input-field');
        if (fields){
            fields.forEach(field => field.reset());
        }
    }

    handlePreencherCep(event){
        const cep = event.target.value;
        console.log(`Cep: ${cep}`)

        preencherCep({cep: cep})
            .then(result => {
                 
                this.template.querySelector('[data-id="rua"]').value = result.logradouro;
                this.template.querySelector('[data-id="cidade"]').value = result.localidade;
                this.template.querySelector('[data-id="estado"]').value = result.estado;
                this.template.querySelector('[data-id="bairro"]').value = result.bairro;

            })
            .catch(error => {           
                console.error('Erro ao buscar CEP: ' + error);
            })
        
    }

    salvarEntrega(event){
        event.preventDefault();
        const campos = event.detail.fields;

        campos.CEP__c = this.template.querySelector('[data-id="cep"]').value;
        campos.Rua__c = this.template.querySelector('[data-id="rua"]').value;
        campos.Cidade__c = this.template.querySelector('[data-id="cidade"]').value;
        campos.Estado__c = this.template.querySelector('[data-id="estado"]').value;
        campos.Bairro__c = this.template.querySelector('[data-id="bairro"]').value;
        

        salvar({entrega: campos})
            .then(result => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Entrega criada com sucesso!',
                    message: 'Entrega criada : ' + result.Id,
                    variant: 'success'
                }));
            })
            .catch(error =>{
                console.log('Erro ao salvar ' + error);
                
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Erro',
                    message: error.body.message,
                    variant: 'error'
                }));               
            })
    }

}