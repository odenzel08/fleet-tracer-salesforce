public with sharing class EntregasController {

    @AuraEnabled(cacheable=true)
    public static List<Entrega__c> getEntregas(){
        return EntregasService.buscarEntregas();
    }

    @AuraEnabled(cacheable=true)
    public static ViaCepIntegration.ViaCepResponse preencherCep(String cep){
        return EntregasService.buscarCep(cep);
    }

    @AuraEnabled
    public static Entrega__c salvar(Entrega__c entrega){
        return EntregasService.salvarEntrega(entrega);
    }
}