/**
 * @author        Teresa Santos
 * @company       Deloitte
 * @date          29/04/2021
 * @description   Clase Selector Invoice
 * @layer         Selector
*/
public without sharing class GOT_InvoiceSelector extends fflib_SObjectSelector
{
  
    public static final Id ONTIER = Schema.SObjectType.GOT_Invoice__c.getRecordTypeInfosByDeveloperName().get('GOT_Ontier').getRecordTypeId();
    public static final Id OTHER_CUSTOMER = Schema.SObjectType.GOT_Invoice__c.getRecordTypeInfosByDeveloperName().get('GOT_CustomerOther').getRecordTypeId();
    public static final Id ITALY_CUSTOMER = Schema.SObjectType.GOT_Invoice__c.getRecordTypeInfosByDeveloperName().get('GOT_CustomerIT').getRecordTypeId();

    public GOT_InvoiceSelector() 
    { 
        super(false, // Do not include FieldSet fields
          false, // Do not enforce Object level security
          false); // Do not enforce Field level security 
    }
    
    public GOT_InvoiceSelector(Boolean includeFieldSetFields) 
    {
        super(includeFieldSetFields);
    }
    
    public GOT_InvoiceSelector(Boolean includeFieldSetFields, Boolean enforceObjectLevel, Boolean includeFieldSecurity) 
    { 
        super(includeFieldSetFields, // Do not include FieldSet fields
          enforceObjectLevel, // Do not enforce Object level security
          includeFieldSecurity); // Do not enforce Field level security 
    }
    
    public Schema.SObjectType getSObjectType() 
    {
        return GOT_Invoice__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() 
    {
        return new List<Schema.SObjectField> 
        {
            GOT_Invoice__c.Id,
            GOT_Invoice__c.Name,
            GOT_Invoice__c.CurrencyIsoCode,
            GOT_Invoice__c.GOT_PointAddressRef__c,
            GOT_Invoice__c.GOT_AddressAuto__c,
            GOT_Invoice__c.GOT_AmendInvoiceRef__c,
            GOT_Invoice__c.GOT_AreaPick__c,
            GOT_Invoice__c.GOT_AccountRef__c,
            GOT_Invoice__c.GOT_InvoiceToRef__c,
            GOT_Invoice__c.RecordTypeId,
            GOT_Invoice__c.GOT_StatusPick__c,
            GOT_Invoice__c.GOT_TypePick__c,
            GOT_Invoice__c.GOT_TRConcept__c,
            GOT_Invoice__c.GOT_TRConcept__c,
            GOT_Invoice__c.GOT_ExpenseConcept__c,
            GOT_Invoice__c.GOT_SupplyConcept__c,
            GOT_Invoice__c.GOT_DueDate__c,
            GOT_Invoice__c.GOT_TRAmountAuto__c,
            GOT_Invoice__c.GOT_ExpenseAmountAuto__c,
            GOT_Invoice__c.GOT_SupplyAmountAuto__c,
            GOT_Invoice__c.GOT_InvoiceDate__c,
            GOT_Invoice__c.GOT_InvoiceConcept__c,
            GOT_Invoice__c.GOT_InvOrderNum__c,
            GOT_Invoice__c.GOT_PaymentTypePick__c,
            GOT_Invoice__c.GOT_InvPlanAmountAuto__c,
            GOT_Invoice__c.GOT_StatusChange__c,
            GOT_Invoice__c.GOT_SalesOfficePick__c,
            GOT_Invoice__c.GOT_IsSpeseGeneralli__c,
            GOT_Invoice__c.GOT_NoticeDueDate__c,
            GOT_Invoice__c.GOT_NoticeDate__c,
            GOT_Invoice__c.GOT_NoticeSeqNum__c,
            GOT_Invoice__c.GOT_AmInvSAPNumAuto__c,
            GOT_Invoice__c.GOT_IsRemoveVAT__c,
            GOT_Invoice__c.GOT_SAPInvoiceNumber__c,
            GOT_Invoice__c.GOT_IsCustVATNumber__c,
            GOT_Invoice__c.GOT_IsForCustNatTerr__c,
            GOT_Invoice__c.GOT_SAPCancelRequestDate__c,
            GOT_Invoice__c.GOT_SAPCancelDate__c,
            GOT_Invoice__c.GOT_MigrationId__c,
            GOT_Invoice__c.GOT_PaymentDate__c,
            GOT_Invoice__c.GOT_AmountWithTax__c,
            GOT_Invoice__c.GOT_TotalAmountAuto__c,
            GOT_Invoice__c.GOT_DepartmentAuto__c,
            GOT_Invoice__c.GOT_LanguagePick__c,
            GOT_Invoice__c.GOT_OrderExchRate__c,
            GOT_Invoice__c.GOT_OrderCurrencyPick__c,
            GOT_Invoice__c.GOT_NoticeCancelDate__c,
            GOT_Invoice__c.GOT_IsApprovedCancel__c

            
        };
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          29/04/2021
    * @description   Método que busca Invoices por su Id
    * @param         setOfInvoiceId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvoices - List<GOT_Invoice__c> - Lista de Invoices encontrados
	*/
    public List<GOT_Invoice__c> findById(Set<Id> setOfInvoiceId)
    {
        List<GOT_Invoice__c> listOfInvoices = (List<GOT_Invoice__c>) Database.query(
            newQueryFactory().
            setCondition('Id IN :setOfInvoiceId').
            toSOQL()
        );
        return listOfInvoices;
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          30/04/2021
    * @description   Método que busca Invoices por Id de Account
    * @param         setOfAccId - Set<Id> - Set con los Id a buscar
	* @return		 listOfInvoices - List<GOT_Invoice__c> - Lista de Invoices encontrados
	*/
    public List<GOT_Invoice__c> findByAccId(Set<Id> setOfAccId)
    {
        String query = String.format
        (
            'SELECT {0} FROM {1} ' +
            'WHERE GOT_AccountRef__c IN :setOfAccId',
            new List<String> 
            {
                getFieldListString(),
                getSObjectName()
            }
        );
        return (List<GOT_Invoice__c>) Database.query(query);
    }

/*
    public List<GOT_InvoiceRelation__c> findRelationByInvoice( )
    {
        
    
    }
*/
    public Map<String, Date> getMaxDateByCountry(Set<String> setOfInvoiceType)
    {
        Map<String, Date> mapOfCountryDates = new Map<String, Date>();
        //Recuperamos el agrupado de fechas por oficina
        //La query va a sacar la fecha más reciente por oficina; la primera que encontremos para cada país es la que se añade a la salida
        //JROM 24/08/2021: se añade el filtro GOT_IssuedDate__c!=null, para que solamente tenga en cuenta las ya emitidas (aunque estén canceladas)
        //JROM 01/10/2021: se añade el filtro GOT_TypePick__c IN :setOfInvoiceType para diferencia suplidos de facturas
        List<AggregateResult> listOfMaxDates = [
                                                SELECT 
                                                    MAX(GOT_InvoiceDate__c) MAX_DATE, 
                                                    GOT_SalesOfficePick__c                                                     
                                                FROM 
                                                    GOT_Invoice__c 
                                                WHERE 
                                                    GOT_SalesOfficePick__c!=null 
                                                    AND GOT_IssuedDate__c!=null
                                                    AND GOT_TypePick__c IN :setOfInvoiceType
                                                GROUP BY 
                                                    GOT_SalesOfficePick__c
                                                ORDER 
                                                    BY MAX(GOT_InvoiceDate__c) DESC
                                                ];
        for (AggregateResult agRes : listOfMaxDates)
        {
            String sCountry = ((String)agRes.get('GOT_SalesOfficePick__c')).left(2);
            if (!mapOfCountryDates.containsKey(sCountry))
            {
                mapOfCountryDates.put(sCountry, (Date)agRes.get('MAX_DATE'));
            }
        }
        return mapOfCountryDates;
    }

    public static Integer getNextNoticeNumber(Integer iYear)
    {
        Integer nextNum = 1;
        if (iYear==null) iYear = Date.today().year();
        List<AggregateResult> listOfResults = [SELECT MAX(GOT_NoticeSeqNum__c) SEQ_NUM FROM GOT_Invoice__c WHERE CALENDAR_YEAR(GOT_NoticeDate__c)= :iYear GROUP BY CALENDAR_YEAR(GOT_NoticeDate__c)];
   
        if (!listOfResults.isEmpty())
        {
            nextNum = Integer.valueOf(listOfResults[0].get('SEQ_NUM'));
            nextNum++;
        }
         
        return nextNum;
    }

}