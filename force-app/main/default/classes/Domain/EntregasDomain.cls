public with sharing class EntregasDomain extends fflib_SObjectDomain{

    public EntregasDomain(List<Entrega__c> records) {
        super(records);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new EntregasDomain(sObjectList);
        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
        
        List<Entrega__c> entregasParaCalculo = new List<Entrega__c>();

        for (Entrega__c e: (List<Entrega__c>) Records) {

            Entrega__c oldEntrega = (Entrega__c) existingRecords.get(e.Id);

            if(e.Status__c == 'Entregue' && oldEntrega.Status__c != 'Entregue'){
                entregasParaCalculo.add(e);
            }
       }
       if (!entregasParaCalculo.isEmpty()) {
            EntregasService.calcularComissao(entregasParaCalculo);
       }
    }
}