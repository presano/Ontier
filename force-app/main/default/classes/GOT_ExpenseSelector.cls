/**
 * @author        Teresa Santos
 * @company       Deloitte
 * @date          29/04/2021
 * @description   Clase Selector Expense
 * @layer         Selector
*/
public without sharing class GOT_ExpenseSelector extends fflib_SObjectSelector
{
  
    public static final Id TRIP = Schema.SObjectType.GOT_Expense__c.getRecordTypeInfosByDeveloperName().get('GOT_Trip').getRecordTypeId();
    public static final Id EXPENSE = Schema.SObjectType.GOT_Expense__c.getRecordTypeInfosByDeveloperName().get('GOT_Expense').getRecordTypeId();
    
    public GOT_ExpenseSelector() 
    { 
        super(false, // Do not include FieldSet fields
          false, // Do not enforce Object level security
          false); // Do not enforce Field level security 
    }
    
    public GOT_ExpenseSelector(Boolean includeFieldSetFields) 
    {
        super(includeFieldSetFields);
    }
    
    public GOT_ExpenseSelector(Boolean includeFieldSetFields, Boolean enforceObjectLevel, Boolean includeFieldSecurity) 
    { 
        super(includeFieldSetFields, // Do not include FieldSet fields
          enforceObjectLevel, // Do not enforce Object level security
          includeFieldSecurity); // Do not enforce Field level security 
    }
    
    public Schema.SObjectType getSObjectType() 
    {
        return GOT_Expense__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() 
    {
        return new List<Schema.SObjectField> 
        {
            GOT_Expense__c.Id,
            GOT_Expense__c.Name,
            GOT_Expense__c.CurrencyIsoCode,
            GOT_Expense__c.GOT_AmountKm__c,
            GOT_Expense__c.GOT_IsBillToCustomer__c,
            GOT_Expense__c.GOT_CashAmount__c,
            GOT_Expense__c.GOT_Comments__c,
            GOT_Expense__c.GOT_CreditAmount__c,
            GOT_Expense__c.GOT_DossierRef__c,
            GOT_Expense__c.GOT_EndDate__c,
            GOT_Expense__c.GOT_ExpFlowLabelAuto__c,
            GOT_Expense__c.GOT_ExpenseSheetRef__c,
            GOT_Expense__c.GOT_Kms__c,
            GOT_Expense__c.RecordTypeId,
            GOT_Expense__c.GOT_StartDate__c,
            GOT_Expense__c.GOT_StatusPick__c,
            GOT_Expense__c.GOT_SubTypePick__c,
            GOT_Expense__c.GOT_TotalAmountAuto__c,
            GOT_Expense__c.GOT_TripEnd__c,
            GOT_Expense__c.GOT_TripInit__c,
            GOT_Expense__c.GOT_TypePick__c,
            GOT_Expense__c.GOT_UserRef__c,
            GOT_Expense__c.GOT_IsBilledAuto__c,
            GOT_Expense__c.GOT_BilledAmount__c,
            GOT_Expense__c.GOT_PendingAmountAuto__c

        };
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          29/04/2021
    * @description   Método que busca Expenses por su Id
    * @param         setOfExpenseId - Set<Id> - Set con los Id a buscar
	* @return		 listOfExpenses - List<GOT_Expense__c> - Lista de Expenses encontrados
	*/
    public List<GOT_Expense__c> findById(Set<Id> setOfExpenseId)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_UserRef__r.Name, toLabel(RecordType.Name) FROM {1} ' +
            'WHERE Id IN :setOfExpenseId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_Expense__c>) Database.query(query);
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Expenses por Id de Dossier
    * @param         setOfDossierId - Set<Id> - Set con los Id a buscar
	* @return		 listOfExpenses - List<GOT_Expense__c> - Lista de Expenses encontrados
	*/
    public List<GOT_Expense__c> findByDossierId(Set<Id> setOfDossierId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_DossierRef__c IN :setOfDossierId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_Expense__c>) Database.query(query);
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Expenses por Id de Expense Sheet
    * @param         setOfExpenseSheetId - Set<Id> - Set con los Id a buscar
	* @return		 listOfExpenses - List<GOT_Expense__c> - Lista de Expenses encontrados
	*/
    public List<GOT_Expense__c> findByExpenseSheetId(Set<Id> setOfExpenseSheetId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_ExpenseSheetRef__c IN :setOfExpenseSheetId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_Expense__c>) Database.query(query);
    }


    /**
	* @author        J. Rubén Olivera
    * @company       Deloitte
    * @date          04/05/2021
    * @description   Método que busca Expenses por Id de Dossier y fechas
    * @param         setOfDossierId - Set<Id> - Set con los Id a buscar
    * @param         startDate - Fecha de inicio
    * @param         endDate - Fecha de fin
	* @return		 listOfExpenses - List<GOT_Expense__c> - Lista de Expenses encontrados
	*/
    public List<GOT_Expense__c> findByDossierDatesAndBillable(Set<Id> setOfDossierId, Date startDate, Date endDate)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_UserRef__r.Name, toLabel(RecordType.Name) FROM {1} ' +
            'WHERE GOT_DossierRef__c IN :setOfDossierId AND GOT_StartDate__c >= :startDate AND GOT_EndDate__c <= :endDate AND GOT_IsBillToCustomer__c=true',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_Expense__c>) Database.query(query);
    }

    public List<GOT_Expense__c> findByDossierDatesAndBillableForInvoice(Set<Id> setOfDossierId, Date startDate, Date endDate)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_UserRef__r.Name, toLabel(RecordType.Name) FROM {1} ' +
            'WHERE GOT_DossierRef__c IN :setOfDossierId AND GOT_StartDate__c >= :startDate AND GOT_EndDate__c <= :endDate AND GOT_IsBillToCustomer__c=true AND GOT_IsMigrationBilled__c=false',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_Expense__c>) Database.query(query);
    }

    public List<GOT_Expense__c> findApprovedByOrderIdAndMaxDate(Set<Id> setOfOrderId, Date maxDate)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_DossierRef__r.GOT_OrderRef__c FROM {1} ' +
            'WHERE GOT_DossierRef__r.GOT_OrderRef__c IN :setOfOrderId AND GOT_EndDate__c <= :maxDate AND GOT_StatusPick__c = \'GOT_Approved\' ',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_Expense__c>) Database.query(query);
    }

    public List<GOT_Expense__c> findApprovedByOrderIdAndMaxDateAutoInvoice(Set<Id> setOfOrderId, Date maxDate)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_DossierRef__r.GOT_OrderRef__c FROM {1} ' +
            'WHERE GOT_DossierRef__r.GOT_OrderRef__c IN :setOfOrderId AND GOT_EndDate__c <= :maxDate AND GOT_StatusPick__c = \'GOT_Approved\' AND (GOT_IsMigrationBilled__c=false OR GOT_IsBilledAuto__c=false)',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_Expense__c>) Database.query(query);
    }


    public List<GOT_Expense__c> findByOrderIdAndDateForInvoice(Set<Id> setOfOrderId, Set<Id> setOfDossierId, Date startDate, Date endDate)
    {
        String sQuery = 'SELECT {0}, GOT_UserRef__r.Name, GOT_DossierRef__r.Name, GOT_DossierRef__r.GOT_OrderRef__c FROM {1} ' +
                            'WHERE GOT_DossierRef__r.GOT_OrderRef__c IN :setOfOrderId  AND GOT_StartDate__c >= :startDate '+
                            'AND GOT_EndDate__c <= :endDate AND GOT_IsBillToCustomer__c=true AND GOT_IsBilledAuto__c=false '+
                            'AND GOT_StatusPick__c=\'GOT_Approved\'';
        if (!setOfDossierId.isEmpty())
        {
            sQuery += ' AND GOT_DossierRef__c IN :setOfDossierId';
        }
        String query = String.format
        (
            sQuery,
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_Expense__c>) Database.query(query);
    }

}