public class GOT_PDFInvoiceHoursController {

    private final GOT_InvoiceRelation__c invoiceRelation;

    
    public String Name;
    public String Categoria;
    
    public GOT_PDFInvoiceHoursController(ApexPages.StandardController stdController) 
    {
        GOT_InvoiceRelation__c invRelation = (GOT_InvoiceRelation__c) stdController.getRecord();
        Id TimeReport = Schema.SObjectType.GOT_InvoiceRelation__c.getRecordTypeInfosByDeveloperName().get('GOT_TimeReport').getRecordTypeId();
        System.debug(invRelation);
        GOT_InvoiceRelationSelector invoiceSelector = new GOT_InvoiceRelationSelector();
        this.invoiceRelation = invoiceSelector.findById(new Set<Id>{invRelation.Id}[0],TimeReport);
        System.debug(invoiceRelation);
        
    }

}
