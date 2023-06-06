public class ConPrimHandler {
    @future
    public static void updateConPhones(Set<Id> primConIds) {
        List<Contact> primCons = [SELECT Id, Phone, AccountId FROM Contact WHERE Id IN :primConIds];
        List<Contact> allRelatedContacts = [SELECT Id, Primary_Contact_Phone__c, AccountId FROM Contact WHERE AccountId IN :primConIds];
        List<Contact> consUpdate = new List<Contact>();
        
        for (Contact pc : primCons) {
            List<Contact> relatedContacts = new List<Contact>();
            for (Contact c : allRelatedContacts) {
                if (c.AccountId == pc.AccountId) {
                    relatedContacts.add(c);
                }
            }
            for (Contact sCon : relatedContacts) {
                if (sCon.Id != pc.Id) {
                    sCon.Primary_Contact_Phone__c = pc.Phone;
                    consUpdate.add(sCon);
                }
            }
        }
        //comentário para salvar mudanças
        if (!consUpdate.isEmpty()) {
            try {
                update consUpdate;
            } catch (DmlException e) {
                System.debug('Falha ao atualizar contato: ' + e.getMessage());
            }
        }
    }
}
