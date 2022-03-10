/**
 * @author        J. Rubén Olivera
 * @company       Deloitte
 * @date          09/03/2021
 * @description   Clase Selector para objeto Account
 * @layer         Selector
*/

public without sharing class GOT_AccountSelector extends fflib_SObjectSelector
{
    public static final Id CUSTOMER = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GOT_Customer').getRecordTypeId();
    public static final Id ONTIER = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GOT_Ontier').getRecordTypeId();

    public GOT_AccountSelector() 
	{ 
        super(false, // Do not include FieldSet fields
          false, // Do not enforce Object level security
          false); // Do not enforce Field level security 
    }
    
    public GOT_AccountSelector(Boolean includeFieldSetFields) 
	{
        super(includeFieldSetFields);
    }
    
    public GOT_AccountSelector(Boolean includeFieldSetFields, Boolean enforceObjectLevel, Boolean includeFieldSecurity) 
	{ 
        super(includeFieldSetFields, // Do not include FieldSet fields
          enforceObjectLevel, // Do not enforce Object level security
          includeFieldSecurity); // Do not enforce Field level security 
    }
    
    public Schema.SObjectType getSObjectType() 
	{
        return Account.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() 
	{
        return new List<Schema.SObjectField> 
		{
            Account.Id,
            Account.ParentId,
            Account.GOT_RootAccountRef__c,
            Account.Name,
            Account.GOT_LastKYCRef__c,
            Account.GOT_OfficePick__c,
            Account.Phone,
            Account.GOT_MobilePhone__c,
            Account.GOT_CommercialName__c,
            Account.Type,
            Account.GOT_DocTypePick__c,
            Account.GOT_DocNumber__c,
            Account.GOT_OrgTypePick__c ,
            Account.BillingCountryCode,
            Account.BillingStreet,
            Account.BillingPostalCode,
            Account.BillingCity,
            Account.BillingState,
            Account.BillingStateCode,
            Account.Fax,
            Account.Website,
            Account.GOT_Email__c,
            Account.GOT_NewSectorPick__c,
            Account.GOT_PaymentTypePick__c,
            Account.GOT_IBAN__c,
            Account.GOT_StatusPick__c,
            Account.GOT_PublicPrivatePick__c,
            Account.AccountNumber

        };
    }


    /**
     * @author        J.Rubén Olivera
     * @company       Deloitte
     * @date          09/03/2021
     * @description   Devuelve cuentas buscando por Id de cuenta
     * @param         setOfAccountId - Set con los Id a buscar
     * @return        List<Account>
    */
    public List<Account> findById(Set<Id> setOfAccountId)
    {
        List<Account> listOfAccount = (List<Account>) Database.query(
            newQueryFactory().
            setCondition('Id IN :setOfAccountId').
            toSOQL()
        );
        return listOfAccount;
    }

     /**
     * @author        J.Rubén Olivera
     * @company       Deloitte
     * @date          22/04/2021
     * @description   Dada una cuenta, devuelve esa cuenta y las cuentas en su jerarquía hacia arriba
     * @param         setOfAccountId - Id con las cuentas a buscar
     * @return        Map<Id, List<Account>> - Key = id de la cuenta a buscar, List<Account> las cuentas de su jerarquía hacia arriba, incluida la misma cuenta
    */
    public Map<Id, List<Account>> findHierarchyUpById(Set<Id> setOfAccountId)
    {
        Map<Id, List<Account>> mapOfHierarchy = new Map<Id, List<Account>>();

        List<Account> listOfAccount = (List<Account>) Database.query(
            newQueryFactory().
            setCondition('Id IN :setOfAccountId').
            toSOQL()
        );

        Set<Id> setOfRootId = new Set<Id>();
        for (Account acc : listOfAccount)
        {
            if (acc.GOT_RootAccountRef__c!=null) 
            {
                setOfRootId.add(acc.GOT_RootAccountRef__c);
            }
        }

        //Recuperamos todas las de la misma jerarquía
        List<Account> listOfAllHierarchy = findByRootId(setOfRootId);
        Map<Id, Account> mapOfAllHierarchy = new Map<Id, Account>(listOfAllHierarchy);
        //Para cada cuenta, la añadimos al mapa
        for (Account acc : listOfAccount)
        {
            //Añadimos la cuenta
            mapOfHierarchy.put(acc.Id, new List<Account>{acc});
            mapOfHierarchy.get(acc.Id).addAll(findParentsInHierarchy(mapOfAllHierarchy, acc.ParentId));
        }
        return mapOfHierarchy;
    }

    //Recursivo, invocado en findHierarchyUpById
    private List<Account> findParentsInHierarchy(Map<Id, Account> mapOfAccount, Id parentId)
    {
        List<Account> listOfParent = new List<Account>();
        if (mapOfAccount.containsKey(parentId))
        {
            Account parent = mapOfAccount.get(parentId);
            listOfParent.add(parent);
            if (parent.ParentId!=null)
            {
                listOfParent.addAll(findParentsInHierarchy(mapOfAccount, parent.ParentId));
            }
        }
        
        return listOfParent;
    }

    /**
     * @author        J.Rubén Olivera
     * @company       Deloitte
     * @date          22/04/2021
     * @description   Devuelve TODAS las cuentas de una jerarquía buscando por RootAccount
     * @param         setOfAccountId - Set con los Id a buscar
     * @return        List<Account>
    */
    public List<Account> findByRootId(Set<Id> setOfAccountId)
    {
        List<Account> listOfAccount = (List<Account>) Database.query(
            newQueryFactory().
            setCondition('(GOT_RootAccountRef__c IN :setOfAccountId) OR (GOT_RootAccountRef__c=null AND Id IN :setOfAccountId)').
            toSOQL()
        );
        return listOfAccount;
    }

    /**
     * @author        Teresa Santos
     * @company       Deloitte
     * @date          18/05/2021
     * @description   Devuelve cuentas buscando por Record Type
     * @param         recordTypeId - Set con los Id a buscar
     * @return        List<Account>
    */
    public List<Account> findByRT(Id recordTypeId)
    {
        List<Account> listOfAccount = (List<Account>) Database.query(
            newQueryFactory().
            setCondition('RecordTypeId = :recordTypeId').
            toSOQL()
        );
        return listOfAccount;
    }

    /**
     * @author        Teresa Santos
     * @company       Deloitte
     * @date          18/05/2021
     * @description   Devuelve cuentas buscando por Id y Record Type
     * @param         setOfAccountId - Set con los Id a buscar
     * @param         recordTypeId - Set con los Id a buscar
     * @return        List<Account>
    */
    public List<Account> findByIdAndRecordType(Set<Id> setOfAccountId, Id recordTypeId)
    {
        List<Account> listOfAccount = (List<Account>) Database.query(
            newQueryFactory().
            setCondition('Id IN :setOfAccountId AND RecordTypeId = :recordTypeId').
            toSOQL()
        );
        return listOfAccount;
    }
}