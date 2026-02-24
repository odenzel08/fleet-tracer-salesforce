public with sharing class ViaCepIntegration {

    public class ViaCepResponse{
        @AuraEnabled public String logradouro;
        @AuraEnabled public String estado;
        @AuraEnabled public String bairro;
        @AuraEnabled public String localidade;
        @AuraEnabled public Boolean erro;
    }

    public static ViaCepResponse buscarCep(String cep){

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://viacep.com.br/ws/' + cep + '/json/');
        request.setMethod('GET'); 

        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            ViaCepResponse viaCepResponse = (ViaCepResponse) JSON.deserialize(response.getBody(), ViaCepResponse.class);
            return viaCepResponse;
        }
        else {
            throw new AuraHandledException('Erro ao buscar CEP: ' + response.getStatus());
        }
    }
    
}