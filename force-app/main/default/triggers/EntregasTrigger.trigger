trigger EntregasTrigger on Entrega__c (before insert, before update, before delete, after insert, after update, after delete) {
    fflib_SObjectDomain.triggerHandler(EntregasDomain.class);
}