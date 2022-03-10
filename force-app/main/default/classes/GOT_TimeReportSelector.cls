/**
 * @author        Teresa Santos
 * @company       Deloitte
 * @date          20/04/2021
 * @description   Clase Selector Time Report
 * @layer         Selector
*/
public without sharing class GOT_TimeReportSelector extends fflib_SObjectSelector
{
  
    public GOT_TimeReportSelector() 
    { 
        super(false, // Do not include FieldSet fields
          false, // Do not enforce Object level security
          false); // Do not enforce Field level security 
    }
    
    public GOT_TimeReportSelector(Boolean includeFieldSetFields) 
    {
        super(includeFieldSetFields);
    }
    
    public GOT_TimeReportSelector(Boolean includeFieldSetFields, Boolean enforceObjectLevel, Boolean includeFieldSecurity) 
    { 
        super(includeFieldSetFields, // Do not include FieldSet fields
          enforceObjectLevel, // Do not enforce Object level security
          includeFieldSecurity); // Do not enforce Field level security 
    }
    
    public Schema.SObjectType getSObjectType() 
    {
        return GOT_TimeReport__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() 
    {
        return new List<Schema.SObjectField> 
        {
            GOT_TimeReport__c.Id,
            GOT_TimeReport__c.Name,
            GOT_TimeReport__c.GOT_IsBillable__c,
            GOT_TimeReport__c.GOT_Comments__c,
            GOT_TimeReport__c.GOT_Date__c,
            GOT_TimeReport__c.CurrencyISOCode,
            GOT_TimeReport__c.GOT_DossierRef__c,
            GOT_TimeReport__c.GOT_Time__c,
            GOT_TimeReport__c.GOT_UserRef__c,
            GOT_TimeReport__c.GOT_EventId__c,
            GOT_TimeReport__c.GOT_HourPrice__c,
            GOT_TimeReport__c.GOT_TimeMinuteAuto__c,
            GOT_TimeReport__c.GOT_AmountAuto__c,
            GOT_TimeReport__c.GOT_PBAmountAuto__c,
            GOT_TimeReport__c.GOT_InvoiceDate__c,
            GOT_TimeReport__c.GOT_MinutesToHoursAuto__c
        };
    }


    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          20/04/2021
    * @description   Método que busca Time Reports por User y Dates
    * @param         setOfUserId - Set<Id> - Set con los Id a buscar
    * @param         startDate - Date - Fechas de startDate
    * @param         endDate - Date - Fechas de endDate
	* @return		 listOfTR - List<GOT_TimeReport__c> - Lista de Time Reports encontrados
	*/
    public List<GOT_TimeReport__c> findByUserAndDate(Set<Id> setOfUserId, Date startDate, Date endDate)
    {
        List<GOT_TimeReport__c> listOfTR = (List<GOT_TimeReport__c>) Database.query(
            newQueryFactory().
            setCondition('GOT_UserRef__c IN :setOfUserId AND GOT_Date__c >= :startDate AND GOT_Date__c <= :endDate ').
            toSOQL()
        );
        return listOfTR;
    }

    /**
	* @author        J. Rubén Olivera
    * @company       Deloitte
    * @date          28/04/2021
    * @description   Método que busca Time Reports por Id
    * @param         setOfTRId - Set<Id> - Set con los Id a buscar
	* @return		 listOfTR - List<GOT_TimeReport__c> - Lista de Time Reports encontrados
	*/
    public List<GOT_TimeReport__c> findById(Set<Id> setOfTRId)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_UserRef__r.Name,GOT_UserRef__r.GOT_OntierProfilePick__c FROM {1} ' +
            'WHERE Id IN :setOfTRId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_TimeReport__c>) Database.query(query);
    }

    /**
	* @author        J. Rubén Olivera
    * @company       Deloitte
    * @date          28/04/2021
    * @description   Método que busca Time Reports por Id que sean facturalbes
    * @param         setOfTRId - Set<Id> - Set con los Id a buscar
	* @return		 listOfTR - List<GOT_TimeReport__c> - Lista de Time Reports encontrados
	*/
    public List<GOT_TimeReport__c> findByIdAndBillable(Set<Id> setOfTRId)
    {
        List<GOT_TimeReport__c> listOfTR = (List<GOT_TimeReport__c>) Database.query(
            newQueryFactory().
            setCondition('Id IN :setOfTRId AND GOT_IsBillable__c=true').
            toSOQL()
        );
        return listOfTR;
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Time Reports por Id de Dossier
    * @param         setOfDossierId - Set<Id> - Set con los Id a buscar
	* @return		 listOfTR - List<GOT_TimeReport__c> - Lista de Expenses encontrados
	*/
    public List<GOT_TimeReport__c> findByDossierId(Set<Id> setOfDossierId)
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
        return (List<GOT_TimeReport__c>) Database.query(query);
    }


    /**
	* @author        J.Rubén Olivera
    * @company       Deloitte
    * @date          04/05/2021
    * @description   Método que busca Time Reports por Id de Dossier
    * @param         setOfDossierId - Set<Id> - Set con los Id a buscar
    * @param         startDate - Fecha de inicio
    * @param         endDate - Fecha de fin
	* @return		 listOfTR - List<GOT_TimeReport__c> - Lista de Expenses encontrados
	*/
    public List<GOT_TimeReport__c> findByDossierDatesAndBillable(Set<Id> setOfDossierId, Date startDate, Date endDate)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_UserRef__r.Name FROM {1} ' +
            'WHERE GOT_DossierRef__c IN :setOfDossierId  AND GOT_Date__c >= :startDate AND GOT_Date__c <= :endDate AND GOT_IsBillable__c=true',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_TimeReport__c>) Database.query(query);
    }

    public List<GOT_TimeReport__c> findByDossierDatesAndBillableForInvoice(Set<Id> setOfDossierId, Date startDate, Date endDate)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_UserRef__r.Name FROM {1} ' +
            'WHERE GOT_DossierRef__c IN :setOfDossierId  AND GOT_Date__c >= :startDate AND GOT_Date__c <= :endDate AND GOT_IsBillable__c=true AND (GOT_IsMigrationBilled__c=false OR GOT_IsBilledAuto__c=false)',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_TimeReport__c>) Database.query(query);
    }

    public List<GOT_TimeReport__c> findByOrderIdAndDateForInvoice(Set<Id> setOfOrderId, Set<Id> setOfDossierId, Date startDate, Date endDate)
    {
        String sQuery = 'SELECT {0}, GOT_UserRef__r.Name, GOT_DossierRef__r.Name, GOT_DossierRef__r.GOT_OrderRef__c FROM {1} ' +
                            'WHERE GOT_DossierRef__r.GOT_OrderRef__c IN :setOfOrderId  AND GOT_Date__c >= :startDate AND GOT_Date__c <= :endDate AND GOT_IsBillable__c=true AND GOT_IsBilledAuto__c=false';
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
        return (List<GOT_TimeReport__c>) Database.query(query);
    }


    public List<GOT_TimeReport__c> findByOrderId(Set<Id> setOfOrderId)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_DossierRef__r.GOT_OrderRef__c FROM {1} ' +
            'WHERE GOT_DossierRef__r.GOT_OrderRef__c IN :setOfOrderId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_TimeReport__c>) Database.query(query);
    }

    public List<GOT_TimeReport__c> findByOrderIdAndMaxDate(Set<Id> setOfOrderId, Date maxDate)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_DossierRef__r.GOT_OrderRef__c FROM {1} ' +
            'WHERE GOT_DossierRef__r.GOT_OrderRef__c IN :setOfOrderId AND GOT_Date__c <= :maxDate ',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_TimeReport__c>) Database.query(query);
    }
    public List<GOT_TimeReport__c> findByOrderIdAndMaxDateAutoInvoice(Set<Id> setOfOrderId, Date maxDate)
    {
        String query = String.format
        (
            'SELECT {0}, GOT_DossierRef__r.GOT_OrderRef__c FROM {1} ' +
            'WHERE GOT_DossierRef__r.GOT_OrderRef__c IN :setOfOrderId AND GOT_Date__c <= :maxDate AND GOT_IsMigrationBilled__c=false',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_TimeReport__c>) Database.query(query);
    }
}