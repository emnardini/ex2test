public class ConPrimHandler {
    @future
    public static void updateConPhones(Set<Id> primConIds) {
        Map<Id, Contact> primCons = new Map<Id, Contact>([SELECT Id, Phone, AccountId FROM Contact WHERE Id IN :primConIds]);
        List<Contact> consUpdate = new List<Contact>();
        for (Contact pc : primCons.values()) {
            List<Contact> relatedContacts = [SELECT Id, Primary_Contact_Phone__c FROM Contact WHERE AccountId = :pc.AccountId];
            for (Contact sCon : relatedContacts) {
                if (sCon.Id != pc.Id) {
                    sCon.Primary_Contact_Phone__c = pc.Phone;
                    consUpdate.add(sCon);
                }
            }
        }
        if (!consUpdate.isEmpty()) {
            try {
                update consUpdate;
            } catch (DmlException e) {
                System.debug('Falha ao atualizar contato: ' + e.getMessage());
            }
        }
    }
}
