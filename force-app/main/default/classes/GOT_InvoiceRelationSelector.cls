/**
 * @author        Teresa Santos
 * @company       Deloitte
 * @date          30/04/2021
 * @description   Clase Selector Invoice Relation
 * @layer         Selector
*/
public without sharing class GOT_InvoiceRelationSelector extends fflib_SObjectSelector
{
  
    public static final Id DOSSIER = Schema.SObjectType.GOT_InvoiceRelation__c.getRecordTypeInfosByDeveloperName().get('GOT_Dossier').getRecordTypeId();
    public static final Id EXPENSE = Schema.SObjectType.GOT_InvoiceRelation__c.getRecordTypeInfosByDeveloperName().get('GOT_Expense').getRecordTypeId();
    public static final Id INVOICEPLAN = Schema.SObjectType.GOT_InvoiceRelation__c.getRecordTypeInfosByDeveloperName().get('GOT_InvoicePlan').getRecordTypeId();
    public static final Id ORDER = Schema.SObjectType.GOT_InvoiceRelation__c.getRecordTypeInfosByDeveloperName().get('GOT_Order').getRecordTypeId();
    public static final Id SUPPLY = Schema.SObjectType.GOT_InvoiceRelation__c.getRecordTypeInfosByDeveloperName().get('GOT_Supply').getRecordTypeId();
    public static final Id TIMEREPORT = Schema.SObjectType.GOT_InvoiceRelation__c.getRecordTypeInfosByDeveloperName().get('GOT_TimeReport').getRecordTypeId();


    public GOT_InvoiceRelationSelector() 
    { 
        super(false, // Do not include FieldSet fields
          false, // Do not enforce Object level security
          false); // Do not enforce Field level security 
    }
    
    public GOT_InvoiceRelationSelector(Boolean includeFieldSetFields) 
    {
        super(includeFieldSetFields);
    }
    
    public GOT_InvoiceRelationSelector(Boolean includeFieldSetFields, Boolean enforceObjectLevel, Boolean includeFieldSecurity) 
    { 
        super(includeFieldSetFields, // Do not include FieldSet fields
          enforceObjectLevel, // Do not enforce Object level security
          includeFieldSecurity); // Do not enforce Field level security 
    }
    
    public Schema.SObjectType getSObjectType() 
    {
        return GOT_InvoiceRelation__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() 
    {
        return new List<Schema.SObjectField> 
        {
            GOT_InvoiceRelation__c.Id,
            GOT_InvoiceRelation__c.Name,
            GOT_InvoiceRelation__c.CurrencyIsoCode,
            GOT_InvoiceRelation__c.GOT_Amount__c,
            GOT_InvoiceRelation__c.GOT_DossierRef__c,
            GOT_InvoiceRelation__c.GOT_ExpenseRef__c,
            GOT_InvoiceRelation__c.GOT_OrderInvPlanRef__c,
            GOT_InvoiceRelation__c.GOT_InvoiceRef__c,
            GOT_InvoiceRelation__c.RecordTypeId,
            GOT_InvoiceRelation__c.GOT_OrderRef__c,
            GOT_InvoiceRelation__c.GOT_SupplyRef__c,
            GOT_InvoiceRelation__c.GOT_Time__c,
            GOT_InvoiceRelation__c.GOT_TimeReportRef__c,
            GOT_InvoiceRelation__c.GOT_IsNoImpactCust__c,
            GOT_InvoiceRelation__c.GOT_OrderInvPlanItemRef__c,
            GOT_InvoiceRelation__c.GOT_Rate__c,
            GOT_InvoiceRelation__c.GOT_Comments__c
        };
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          29/04/2021
    * @description   Método que busca Invoice Relations por su Id
    * @param         setOfInvRelId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvRel - List<GOT_InvoiceRelation__c> - Lista de Invoices encontrados
	*/
    public List<GOT_InvoiceRelation__c> findById(Set<Id> setOfInvRelId)
    {
        List<GOT_InvoiceRelation__c> listOfInvRel = (List<GOT_InvoiceRelation__c>) Database.query(
            newQueryFactory().
            setCondition('Id IN :setOfInvRelId').
            toSOQL()
        );
        return listOfInvRel;
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Invoice Relations por Id de Invoice
    * @param         setOfInvoiceId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvRel - List<GOT_InvoiceRelation__c> - Lista de Invoice Relation encontrados
	*/
    public List<GOT_InvoiceRelation__c> findByInvoiceId(Set<Id> setOfInvoiceId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_InvoiceRef__c IN :setOfInvoiceId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_InvoiceRelation__c>) Database.query(query);
    }


    public List<GOT_InvoiceRelation__c> findByInvoiceIdAndRecordType(Set<Id> setOfInvoiceId, ID rtId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_InvoiceRef__c IN :setOfInvoiceId AND RecordTypeId = :rtId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_InvoiceRelation__c>) Database.query(query);
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Invoice Relations por Id de Time Report
    * @param         setOfTRId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvRel - List<GOT_InvoiceRelation__c> - Lista de Invoice Relation encontrados
	*/
    public List<GOT_InvoiceRelation__c> findByTRId(Set<Id> setOfTRId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_TimeReportRef__c IN :setOfTRId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_InvoiceRelation__c>) Database.query(query);
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Invoice Relations por Id de Supply
    * @param         setOfSupplyId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvRel - List<GOT_InvoiceRelation__c> - Lista de Invoice Relation encontrados
	*/
    public List<GOT_InvoiceRelation__c> findBySupplyId(Set<Id> setOfSupplyId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_SupplyRef__c IN :setOfSupplyId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_InvoiceRelation__c>) Database.query(query);
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Invoice Relations por Id de Order
    * @param         setOfOrdersId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvRel - List<GOT_InvoiceRelation__c> - Lista de Invoice Relation encontrados
	*/
    public List<GOT_InvoiceRelation__c> findByOrderId(Set<Id> setOfOrdersId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_OrderRef__c IN :setOfOrdersId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_InvoiceRelation__c>) Database.query(query);
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Invoice Relations por Id de Invoicing Plan
    * @param         setOfInvPlanId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvRel - List<GOT_InvoiceRelation__c> - Lista de Invoice Relation encontrados
	*/
    public List<GOT_InvoiceRelation__c> findByInvPlanId(Set<Id> setOfInvPlanId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_OrderInvPlanRef__c IN :setOfInvPlanId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_InvoiceRelation__c>) Database.query(query);
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Invoice Relations por Id de Expense
    * @param         setOfExpensesId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvRel - List<GOT_InvoiceRelation__c> - Lista de Invoice Relation encontrados
	*/
    public List<GOT_InvoiceRelation__c> findByExpenseId(Set<Id> setOfExpensesId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_ExpenseRef__c IN :setOfExpensesId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_InvoiceRelation__c>) Database.query(query);
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Invoice Relations por Id de Dossier
    * @param         setOfDossiersId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvRel - List<GOT_InvoiceRelation__c> - Lista de Invoice Relation encontrados
	*/
    public List<GOT_InvoiceRelation__c> findByDossierId(Set<Id> setOfDossiersId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_DossierRef__c IN :setOfDossiersId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_InvoiceRelation__c>) Database.query(query);
    }



    //Totales solo de facturas no rechazadas
    //JROM 11/02/2022 - Se hace el cálculo en la divisa del encargo, con el cambio de divisa de cuando se generó la factura
    //Si no hay divisa del encargo (anteriores a evolutivo multidivisa), no se hace cálculo, ya estará en la divisa del encargo
    public Map<Id, Decimal> findTotalByFieldId(String fieldAPIName, Set<Id> setOfIds)
    {
        String relName = fieldAPIName.replace('__c', '__r');
        String query = String.format
        (
            'SELECT '+fieldAPIName+', GOT_Amount__c, GOT_InvoiceRef__r.GOT_OrderExchRate__c FROM {1} ' +
            'WHERE '+fieldAPIName+' IN :setOfIds AND GOT_InvoiceRef__r.GOT_StatusPick__c!=\'GOT_Rejected\' ',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );

        List<GOT_InvoiceRelation__c> listOfResults = (List<GOT_InvoiceRelation__c>) Database.query(query);

        Map<Id, Decimal> mapOfResults = new Map<Id, Decimal>();
        for (GOT_InvoiceRelation__c result : listOfResults)
        {
            Id elementId = (Id)result.get(fieldAPIName);
             
            Decimal exchangeRate = result.GOT_InvoiceRef__r.GOT_OrderExchRate__c;
            if (exchangeRate==null || exchangeRate==0) exchangeRate = 1;

            Decimal elementAmount = result.GOT_Amount__c;
            if (elementAmount==null) elementAmount = 0;
            elementAmount = elementAmount/exchangeRate; //Conversión a divisa del encargo, dividiendo
            
            if (mapOfResults.containsKey(elementId))
            {
                Decimal auxAmount = mapOfResults.get(elementId)+elementAmount;
                mapOfResults.put(elementId, auxAmount);
            }
            else
            {
                mapOfResults.put(elementId, elementAmount);
            }
        }
        
        return mapOfResults; 
    }

}