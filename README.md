# 🚚 Fleet Tracer - Sistema de Gestão de Logística

O **Fleet Tracer** é uma solução completa desenvolvida na plataforma Salesforce para gerenciar entregas, automatizar o preenchimento de endereços via integração e calcular comissões de motoristas de forma performática.

---

## 🏗️ Arquitetura Low-Code (Configuração e Regras de Negócio)

Antes do desenvolvimento de código, a solução foi estruturada utilizando as ferramentas declarativas do Salesforce para garantir integridade dos dados e agilidade.

### 1. Modelo de Dados (Objetos)
- **Entrega__c**: Objeto customizado para rastrear o status, valor, CEP e endereço das mercadorias.
- **Motorista__c (ou Contact)**: Objeto para gerir os profissionais, com campos de controle de comissão acumulada.
- **Relacionamento**: Lookup de `Entrega__c` para `Motorista__c`.

### 2. Integridade e Validação
Para garantir dados limpos, foram implementadas regras de validação nativas:
- **Validação de Data de Nascimento**: Impede o cadastro de motoristas com data futura ou menores de 18 anos.
- **Campos obrigatórios**
- **Validação de campos**

### 3. Relatórios e Dashboards
Painel para analisar os estados com mais entregas:
- **Relátorio de resumo**: Agrupado pelo campo Estado
- **Dashboard**: Painel de rosca, exibindo todos estados e a quantidade de entregas para cada um.

---

## 🧠 Documentação Técnica (Pro-Code)

Abaixo, o detalhamento do raciocínio lógico aplicado no desenvolvimento Apex e LWC.

### ⚡ Back-end (Apex)

#### **Classe `ComissaoService`**
- **Método `calcularComissao(List<Entrega__c>)`**: 
    - Implementa lógica de acumulação de valores utilizando `Map<Id, Double>` para consolidar as comissões por Motorista, evitando múltiplas operações DML (Bulkificação).
    - Realiza a verificação de existência do ID no Map: se presente, incrementa o valor; se não, inicializa o registro.
    - Efetua a atualização dos registros de Motorista em uma única operação DML (`update`) após a iteração, respeitando os *Governor Limits*.

#### **Trigger Handler (`EntregasDomain`)**
- **After Update**: Filtra registros aptos para processamento, verificando se o `Status__c` foi alterado para "Concluído" através da comparação entre `OldMap` e `NewMap`. Isso evita que a trigger dispare desnecessariamente em qualquer edição.

#### **Integração ViaCEP (`ViaCepIntegration`)**
- **Deserialização e Wrapper**: Utiliza uma classe auxiliar `ViaCepResponse` para mapear o JSON de retorno. O método valida o `StatusCode` (200) e realiza o `JSON.deserialize`.
- **Tratamento de Erros**: Lança `AuraHandledException` para garantir que erros de API sejam comunicados de forma amigável ao usuário no frontend.

---

### 💻 Front-end (LWC)

#### **Componente `registroEntrega`**
- **`handlePreencheCep`**: Chama o Apex de forma imperativa. Ao receber o retorno, utiliza `querySelector` com `data-id` para popular programaticamente os campos de endereço no formulário.
- **`salvarEntrega`**: Intercepta o envio padrão do `lightning-record-edit-form` via `preventDefault()`. Isso permite capturar os dados preenchidos via API e validar o objeto antes do salvamento manual via Controller.
- **Feedback Visual**: Implementação de `ShowToastEvent` para notificações de sucesso e erro.

#### **Componente `entregaDoDia`**
- **Data Flattening (Achatamento)**: No recebimento dos dados via `@wire`, utiliza o método `.map()` e o *Spread Operator* para criar a propriedade `NomeMotorista`. Isso permite exibir dados de objetos relacionados (Lookup) dentro do `lightning-datatable`.
- **Reset de campos**: O método `atualizarEntregas` é acionado após os botão `Limpar Campos` ele aciona uma função reset que limpa os campos do formulário.

---

## 🛠️ Tecnologias Utilizadas
- Salesforce LWC & Apex
- SOQL
- REST API (ViaCEP)
- Triggers
- Salesforce Dashboards & Reports
- SLDS (Design System)
