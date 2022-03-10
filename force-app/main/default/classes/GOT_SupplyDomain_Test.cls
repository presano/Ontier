/** 
* @author			Teresa Santos     
* @company          Deloitte 
* @date             01/06/2021
* @description      Clase Test para la clase GOT_SupplyDomain
* @layer			Selector
*/
@isTest (SeeAllData=false)
public class GOT_SupplyDomain_Test {

    /**
    * @author        Teresa Santos
    * @company       Deloitte
    * @date          01/06/2021
    * @description   Método que comprueba que el Supply se actualiza correctamente
    */
@testSetup static void setup() {
    GOT_BypassCS__c oBypass = GOT_BypassCS__c.getOrgDefaults();
        oBypass.GOT_IsBypassTrigger__c = true;
        oBypass.GOT_IsBypassVR__c = true;
        upsert oBypass;
        
        Id customerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GOT_Customer').getRecordTypeId();
        Id ontierAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GOT_Ontier').getRecordTypeId();
        Id customerDossierRTId = Schema.SObjectType.GOT_Dossier__c.getRecordTypeInfosByDeveloperName().get('GOT_Customer').getRecordTypeId();
        Id customerInvRTId = Schema.SObjectType.GOT_Invoice__c.getRecordTypeInfosByDeveloperName().get('GOT_CustomerOther').getRecordTypeId();
    
        Account acc = new Account();
        acc.RecordTypeId = customerAccRTId;
        acc.Name = 'AccTest';
        acc.Type = 'GOT_Person';
        acc.GOT_DocTypePick__c = 'GOT_TaxId';
        acc.GOT_DocNumber__c = '62625794Z';
        acc.GOT_OrgTypePick__c = 'GOT_Customer';
        acc.GOT_NewSectorPick__c = 'Z009';
        acc.GOT_StatusPick__c = 'GOT_Potential';
        acc.CurrencyIsoCode = 'EUR';
        insert acc;
            
 		ContactPointAddress cpa1 = new ContactPointAddress();
        cpa1.AddressType = 'GOT_Billing';
        cpa1.ActiveFromDate = Date.today();
        cpa1.Name = 'CPA';
        cpa1.Street = 'Calle';
        cpa1.PostalCode = '28000';
        cpa1.City = 'Madrid';
        cpa1.CountryCode = 'ES';
        //cpa1.State = 'Madrid';
        cpa1.StateCode = '28';
        cpa1.ParentId = acc.Id;
        insert cpa1;
    
    
        Account ontier = new Account();
        ontier.RecordTypeId = ontierAccRTId;
        ontier.Name = 'AccTest2';
        ontier.GOT_StatusPick__c = 'GOT_Active';
        ontier.CurrencyIsoCode = 'EUR';
        insert ontier;

        User user = new User();
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        user.LastName = 'last';
        user.Email = 'puser000@amamama.com';
        user.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        user.CompanyName = 'TEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.GOT_OntierProfilePick__c = '001';
        user.GOT_OfficePick__c = 'ESMD';
        user.GOT_AreaPick__c = 'ENE';
        insert user;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.AccountId = acc.Id;
        opp.StageName = 'Qualification';
        opp.GOT_SalesOfficePick__c = 'ESMD';
        opp.GOT_AreaPick__c = 'ENE';
        opp.GOT_MLPPick__c = 'GOT_No';
        opp.GOT_MainAssocUserRef__c = user.Id;
        opp.CloseDate = Date.today().addDays(5);
        opp.GOT_OntierOfficeRef__c = ontier.Id;
        opp.GOT_IsNotOpponent__c = true;
        opp.GOT_NotOpponentReason__c ='Test';
        insert opp;

        Quote quote = new Quote();
        quote.Name = 'TestQuote';
        quote.Status = 'Draft';
        quote.OpportunityId = opp.Id;
        insert quote;

        Order order = new Order ();
        order.AccountId = acc.Id;
        order.OpportunityId = opp.Id;
        order.QuoteId = quote.Id;
        order.Status = 'GOT_Open';
        order.EffectiveDate = Date.today();
        order.GOT_MainAssocUserRef__c = user.Id;
        order.GOT_SalesOfficePick__c = 'ESMD';
        order.GOT_ReferenceOfficePick__c = 'ESMD';
        insert order;

        GOT_Dossier__c dossier = new GOT_Dossier__c();
        dossier.RecordTypeId = customerDossierRTId;
        dossier.GOT_OpportunityRef__c = opp.Id;
        dossier.GOT_OrderRef__c = order.Id;
        dossier.GOT_OfficePick__c = 'ESMD';
        dossier.GOT_AreaPick__c = 'ENE';
        dossier.GOT_Subject__c = 'Test';
        dossier.GOT_OpenDate__c = Date.today();
        dossier.GOT_StatusPick__c = 'GOT_Open';
        dossier.GOT_OfficeFolderRef__c = ontier.Id;
        dossier.CurrencyIsoCode = 'GBP';
        insert dossier;

        GOT_Supply__c supply = new GOT_Supply__c();
        supply.GOT_DossierRef__c = dossier.Id;
        supply.GOT_StatusPick__c = 'GOT_Pending';
        supply.GOT_Comments__c = 'Test';
        supply.GOT_Date__c = Date.today();
        supply.GOT_Amount__c = 100;
        supply.CurrencyIsoCode = 'EUR';
        insert supply;
    
     GOT_Invoice__c invoice2 = new GOT_Invoice__c();
        invoice2.RecordTypeId = customerInvRTId;
        invoice2.GOT_AccountRef__c = acc.Id;
        invoice2.GOT_SalesOfficePick__c = 'ESMD';
        invoice2.GOT_AreaPick__c = 'ENE';
        invoice2.GOT_InvoiceToRef__c = acc.Id;
        invoice2.GOT_PointAddressRef__c = cpa1.Id;
        invoice2.GOT_TypePick__c = 'GOT_Standard';
        invoice2.CurrencyIsoCode = 'EUR';
        invoice2.GOT_Comments__c = 'Test';
        invoice2.GOT_InvoiceDate__c = Date.today();
        invoice2.GOT_DueDate__c = Date.today();
        invoice2.GOT_TRConcept__c = 'Test2';
        invoice2.GOT_ExpenseConcept__c = 'Test';
        invoice2.GOT_SupplyConcept__c = 'Test';
    	invoice2.GOT_StatusPick__c = 'GOT_Paid';
        
        insert invoice2;
    GOT_InvoiceRelation__c inv2 = new GOT_InvoiceRelation__c();
      inv2.RecordTypeId = GOT_InvoiceRelationSelector.TIMEREPORT;
     	inv2.GOT_InvoiceRef__c = invoice2.Id;
        inv2.GOT_Amount__c = 222;
    	inv2.GOT_SupplyRef__c=supply.Id;
        insert inv2;
    
     oBypass.GOT_IsBypassTrigger__c = false;
        oBypass.GOT_IsBypassVR__c = false;
        upsert oBypass;
}
    
    @isTest
    public static void updateProduct(){

        
        Test.startTest();
        GOT_Supply__c supp = [select Id, CurrencyIsoCode, GOT_StatusPick__c from GOT_Supply__c where GOT_Amount__c = 100 limit 1];
        supp.CurrencyIsoCode = 'GBP';
        supp.GOT_ApprovalProcess__c = 'P';
        supp.GOT_StatusPick__c = 'GOT_InReview';
        
        try{
        	
            update supp;
        
        }catch(Exception e){
            
            e.getMessage();
        }
        
       
        Test.stopTest();

    }

 
     @isTest
    static void  deleteTest(){

        
 		GOT_Supply__c supply = [select Id, CurrencyIsoCode, GOT_StatusPick__c from GOT_Supply__c where GOT_Amount__c = 100 Limit 1];
         
        Test.startTest();
        
        try{
           
            delete supply; 
        
        }catch(Exception e){
            
            e.getMessage();
        }
        
        Test.stopTest();
        
        
    }
    
      @isTest
    static void  onBeforeInsertTest(){

        
 		 GOT_Supply__c supply = new GOT_Supply__c();
        supply.GOT_StatusPick__c = 'GOT_Pending';
        supply.GOT_Comments__c = 'Test';
        supply.GOT_Date__c = Date.today();
        supply.GOT_Amount__c = 100;
        supply.CurrencyIsoCode = 'EUR';
         
        Test.startTest();
       
        try {
         
            insert supply;
        
        }catch( Exception e){
            
            e.getMessage();
        }
        
        Test.stopTest();
        
        
    }
    
     @isTest
    static void  validateUpdatedeleteTest(){

        List<GOT_Supply__c> supply = [select Id, CurrencyIsoCode, GOT_StatusPick__c from GOT_Supply__c where GOT_Amount__c = 100 Limit 1];
         Map<Id, GOT_Supply__c> mapOfSupply = new Map<Id, GOT_Supply__c> (supply);
 		GOT_InvoiceRelation__c invrelation = [select Id, GOT_SupplyRef__c FROM GOT_InvoiceRelation__c where GOT_InvoiceRef__r.GOT_StatusPick__c!='GOT_Rejected' AND GOT_SupplyRef__c IN :mapOfSupply.keySet() Limit 1];
        invrelation.GOT_SupplyRef__c=supply[0].Id;
         
        Test.startTest();
        
        delete invrelation;
        
        Test.stopTest();
        
        
    }
    
    
     @isTest
    static void  setCurrencyIsoCodeTest(){

        List<GOT_Supply__c> supplies = [select Id, CurrencyIsoCode, GOT_StatusPick__c, GOT_DossierRef__c, GOT_Amount__c from GOT_Supply__c where GOT_Amount__c = 100 Limit 1];
       
        Test.startTest();
        
        GOT_SupplyDomain supply= new   GOT_SupplyDomain(supplies);
       supply.setCurrencyIsoCode(supplies);
        
        Test.stopTest();
        
        
    }

}