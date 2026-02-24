public with sharing class EntregasService {

    public static void calcularComissao(List<Entrega__c> entregas){

        Map<Id, Double> comissaoPorMotoristas = new Map<Id, Double>();

        for (Entrega__c entrega : entregas){

            Double valorComissao = entrega.Valor_Entrega__c * 0.10;

            if(!comissaoPorMotoristas.containsKey(entrega.Motorista__c)){
                comissaoPorMotoristas.put(
                    entrega.Motorista__c, valorComissao);
            } else {
                comissaoPorMotoristas.put(entrega.Motorista__c,
                comissaoPorMotoristas.get(entrega.Motorista__c) + valorComissao);
            }   
        }

        List<Motorista__c> atualizarMotoristas = [
            SELECT Id, Comissao__c
            FROM Motorista__c
            WHERE Id IN :comissaoPorMotoristas.keySet()
        ];

        for (Motorista__c moto : atualizarMotoristas){

            moto.Comissao__c = (moto.Comissao__c == null ? 0 : moto.Comissao__c) + comissaoPorMotoristas.get(moto.Id);
        }
        if (!atualizarMotoristas.isEmpty()) {
            update atualizarMotoristas;
        }
        
    }

    public static List<Entrega__c> buscarEntregas(){
        try {
            List<Entrega__c> entregas = [
                SELECT Id, Valor_Entrega__c, Motorista__r.Name, Estado__c, Status__c
                FROM Entrega__c 
                WHERE CreatedDate = TODAY
                ORDER BY CreatedDate DESC LIMIT 10
            ];
            return entregas;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    public static ViaCepIntegration.ViaCepResponse buscarCep(String cep){
        
        String cepTratado = cep.replaceAll('[^0-9]', '');

        ViaCepIntegration.ViaCepResponse resultado = ViaCepIntegration.buscarCep(cepTratado);
        if (resultado.erro == true || resultado == null) {
            throw new AuraHandledException('Não foi possível encontrar o CEP digitado.');
        }
        return resultado;
    }

    public static Entrega__c salvarEntrega(Entrega__c entrega){
        try {
            insert entrega;
            return entrega;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage() + ' ' + e.getStackTraceString());
        }
    }
}