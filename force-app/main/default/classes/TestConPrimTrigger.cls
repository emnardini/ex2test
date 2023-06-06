@isTest
public class TestConPrimTrigger {
    @isTest
    static void testConPrimTrigHand() {
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
        
        Contact primContact = new Contact(
            FirstName = 'Nome',
            LastName = 'Sobrenome',
            AccountId = testAcc.Id,
            Primary_Contact__c = true
        );
        insert primContact;
        
        Contact secContact = new Contact(
            FirstName = 'Nome2',
            LastName = 'Sobrenome2',
            AccountId = testAcc.Id,
            Primary_Contact__c = false
        );
        insert secContact;
        
        Test.startTest();

        secContact.Primary_Contact__c = true;
        Database.SaveResult sr = Database.update(secContact, false);

        Test.stopTest();

        System.assert(!sr.isSuccess(), 'O teste deveria fracassar, mas não fracassou');
        System.assert(sr.getErrors().size() > 0, 'Esperava ao menos um erro, mas não aconteceu');
        System.assertEquals('Já existe contato primário.', sr.getErrors()[0].getMessage(), 'Erro');
    }
}
