/**
* @author        Teresa Santos
* @company       Deloitte
* @date          20/04/2021
* @description   Clase Domain para objeto Supply
* @layer         Domain
*/
public without sharing class GOT_SupplyDomain extends fflib_SObjectDomain 
{
    public GOT_SupplyDomain (List<GOT_Supply__c> sObjectList)
    {
    	super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable 
    {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) 
        {
            return new GOT_SupplyDomain(sObjectList);
        }
    }

    /**
     * @author        Teresa Santos
     * @company       Deloitte
     * @description   Método que se ejecuta en el onValidate before Insert
    */
    public override void onValidate()
	{
    }

    /**
     * @author        Teresa Santos
     * @company       Deloitte
     * @description   Método que se ejecuta en el onValidate before Update
    */
    public override void onValidate(Map<Id,SObject> existingRecords)
    {
       //Validar cambio de estado (State model)
       List<GOT_Supply__c> listOfSupplyChangedStatus = (List<GOT_Supply__c>) getChangedRecords(new Set<String>{'GOT_StatusPick__c'});
        System.debug(listOfSupplyChangedStatus);
       if (!listOfSupplyChangedStatus.isEmpty())
       {
           GOT_StateModelValidator.validate('GOT_Supply__c', 'GOT_StatusPick__c', existingRecords, listOfSupplyChangedStatus); 
       }

       List<GOT_Supply__c> listOfChangedSupply = (List<GOT_Supply__c>) getChangedRecords(new Set<String>{'GOT_StatusPick__c','GOT_Date__c','GOT_Comments__c','GOT_Amount__c'});
        if (!listOfChangedSupply.isEmpty())
        {
            validateUpdateDelete(listOfChangedSupply);
        }

    }

    public override void onBeforeDelete() 
    {
        validateUpdateDelete(Records);
    }

    public void validateUpdateDelete(List<GOT_Supply__c> listOfSupply)
    {
        Map<Id, GOT_Supply__c> mapOfSupply = new Map<Id, GOT_Supply__c> (listOfSupply);
        List<GOT_InvoiceRelation__c> listOfInvRel = [SELECT Id, GOT_SupplyRef__c FROM GOT_InvoiceRelation__c WHERE GOT_SupplyRef__c IN :mapOfSupply.keySet() AND GOT_InvoiceRef__r.GOT_StatusPick__c!='GOT_Rejected'];
        if (!listOfInvRel.isEmpty())
        {
            Set<Id> setOfSupInvId = new Set<Id>();
            for (GOT_InvoiceRelation__c invRel : listOfInvRel)
            {
                setOfSupInvId.add(invRel.GOT_SupplyRef__c);
            }

            for (GOT_Supply__c sup : listOfSupply)
            {
                if (setOfSupInvId.contains(sup.Id)) sup.addError(System.Label.GOT_ERR_NoUpdateDeleteRecordInvoiced);
            }
        }
    }


    /**
     * @author        J. Rubén Olivera
     * @company       Deloitte
     * @description   Método que se ejecuta en el beforeInsert
    */
    public override void onBeforeInsert() 
    {
        setCurrencyIsoCode(Records);
    }
	
	/**
     * @author        Teresa Santos
     * @company       Deloitte
     * @description   Método que se ejecuta en el beforeUpdate
    */
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) 
    {
        List<GOT_Supply__c> listOfChangedCurr = (List<GOT_Supply__c>) getChangedRecords(new Set<String>{'CurrencyIsoCode'});
        Map<Id, GOT_Supply__c> mapOfOldSupply = (Map<Id, GOT_Supply__c>) existingRecords;
        for(GOT_Supply__c theSupply: listOfChangedCurr)
        {
            theSupply.CurrencyIsoCode = mapOfOldSupply.get(theSupply.Id).CurrencyIsoCode;
        }
    }

    /**
     * @author        Teresa Santos
     * @company       Deloitte
     * @description   Método que da valor a CurrencyIsoCode con el valor del expediente
    */
    public void setCurrencyIsoCode(List<GOT_Supply__c> listOfSupplies)
    {
        Set<Id> setOfDossierId = new Set<Id>();
        for (GOT_Supply__c supply : listOfSupplies)
        {
            setOfDossierId.add(supply.GOT_DossierRef__c);
        }
        GOT_DossierSelector dossierSelector = new GOT_DossierSelector();
        List<GOT_Dossier__c> listOfDossier = dossierSelector.findById(setOfDossierId);
        Map<Id, GOT_Dossier__c> mapOfDossier = new Map<Id, GOT_Dossier__c>(listOfDossier);
        Map<String, Decimal> mapOfConversion =  GOT_CurrencyUtils.getDefaultRates();
        for (GOT_Supply__c supply : listOfSupplies)
        {
            String sourceIsoCode = supply.CurrencyIsoCode;
            String targetIsoCode = mapOfDossier.get(supply.GOT_DossierRef__c).CurrencyIsoCode;
            supply.GOT_Amount__c = GOT_CurrencyUtils.convertValueToCurrency(mapOfConversion, sourceIsoCode, targetIsoCode, supply.GOT_Amount__c);
            supply.CurrencyIsoCode = targetIsoCode;
        }
    }
 }