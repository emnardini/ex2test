trigger ConPrimTrigger on Contact (before insert, before update) {
    Set<Id> primConIds = new Set<Id>();
    Set<Id> accIds = new Set<Id>();
    for (Contact c : Trigger.new) {
        accIds.add(c.AccountId);
    }
    Map<Id, Contact> primCons = new Map<Id, Contact>();
    for (Contact c : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accIds AND Primary_Contact__c = true]) {
        primCons.put(c.AccountId, c);
    }
    for (Contact c : Trigger.new) {
        //validação de contato primário já existente
        if (c.Primary_Contact__c && primCons.containsKey(c.AccountId)) {
            c.Primary_Contact__c.addError('Já existe contato primário.');
        } else if (c.Primary_Contact__c) {
            primConIds.add(c.Id);
        }
    }
    if (primConIds.isEmpty() == false) {
        ConPrimHandler.updateConPhones(primConIds);
    }
}
