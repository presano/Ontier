/**
 * @author        Pedro Tirado
 * @company       Deloitte
 * @date          07/07/2021
 * @description   Clase Controller para GOT_InvoicePDFVF 
 * @layer         Controller
*/
public class GOT_InvoicePDFVFController {
    
    public static final String image_file_name = 'OnTier_Logo_339x93';
    
    private final GOT_Invoice__c invoice;
    public List<GOT_InvoiceRelation__c> invoiceRelation{get; set;}
    public List<GOT_TimeReport__c> timeReports{get; set;}
    public final ContentVersion contentversion {get;set;}
    
    public Decimal sumaTotal {get; set;}
    public Decimal onorari;
    public Decimal onorariMinusGeneral;
    public Decimal totaleImponibile;
    public Decimal totaleImponibile4Percent;
    public Decimal totaleImponibileIVA;
    public Decimal iva;
    public Decimal netoAPagare;
    
    public String onorari_label {get; set;}
    public String onorariMinusGeneral_label {get;set;}
    public String totaleImponibile_label {get;set;}
    public String totaleImponibile4Percent_label {get;set;}
    public String totaleImponibileIVA_label {get;set;}
    public String iva_label {get;set;}
    public String netoAPagare_label {get;set;}
    public String expense_label {get; set;}
    public String supply_label {get; set;}


    public GOT_InvoicePDFVFController(ApexPages.StandardController stdController) 
    {
       
        //Llamadas a los selectores
        GOT_Invoice__c  inv=(GOT_Invoice__c) stdController.getRecord();
        GOT_InvoiceSelector invoiceSelector = new GOT_InvoiceSelector();
        GOT_InvoiceRelationSelector invoiceSelector1 = new GOT_InvoiceRelationSelector();
        GOT_TimeReportSelector timeReportSelector = new GOT_TimeReportSelector();
        GOT_UserSelector userSelector = new GOT_UserSelector();


       this.invoice = invoiceSelector.findById(new Set<Id>{inv.Id})[0];
     invoiceRelation = invoiceSelector1.findByInvoiceIdAndRecordType(new Set<Id>{inv.Id},GOT_InvoiceRelationSelector.TimeReport);
       System.debug(invoiceRelation);

       //Recogida de los TimeReports del invoice
       Set<Id> reports= new Set<Id>();
      
        for(GOT_InvoiceRelation__c invoice: invoiceRelation){

            reports.add(invoice.GOT_TimeReportRef__c);
           
        }

        timeReports = timeReportSelector.findById(reports);
       

        //Calculo de total de las horas
        List<Decimal> totalHoras= new List<Decimal>();
        for(GOT_TimeReport__c horas: timeReports){

            totalHoras.add(horas.GOT_MinutesToHoursAuto__c);
           
     
        }

        sumaTotal=0;
        for(Decimal suma: totalHoras){

            sumaTotal= sumaTotal+suma;
        }


       

        contentversion = [select Id FROM ContentVersion WHERE ContentDocument.title=:image_file_name LIMIT 1];        

        onorari = invoice.GOT_InvPlanAmountAuto__c;
        onorari_label = formatNumberAsString(onorari);
        
        if (this.invoice.GOT_IsSpeseGeneralli__c)
        {
            onorariMinusGeneral = onorari * 0.15;            
        }
        else
        {
            onorariMinusGeneral = 0;
        }

        onorariMinusGeneral_label = formatNumberAsString(onorariMinusGeneral);
        
        totaleImponibile = (onorari + onorariMinusGeneral + invoice.GOT_ExpenseAmountAuto__c);
        totaleImponibile_label = formatNumberAsString(totaleImponibile);
        
        totaleImponibile4Percent = (totaleImponibile * 0.04);
        totaleImponibile4Percent_label = formatNumberAsString(totaleImponibile4Percent);
        
        totaleImponibileIVA = (totaleImponibile + totaleImponibile4Percent);
        totaleImponibileIVA_label = formatNumberAsString(totaleImponibileIVA);
        
        iva = (totaleImponibileIVA * 0.22);
        if (this.invoice.GOT_IsRemoveVAT__c) iva = 0;
        iva_label = formatNumberAsString(iva);
        
        netoAPagare = (totaleImponibileIVA + iva + invoice.GOT_SupplyAmountAuto__c);
        netoAPagare_label = formatNumberAsString(netoAPagare);

        supply_label = this.invoice.GOT_SupplyAmountAuto__c!=null?formatNumberAsString(this.invoice.GOT_SupplyAmountAuto__c):'0,00';
        expense_label = this.invoice.GOT_ExpenseAmountAuto__c!=null?formatNumberAsString(this.invoice.GOT_ExpenseAmountAuto__c):'0,00';
                
    }


    private String formatNumberAsString(Decimal dInput)
    {
        Decimal dNumber = dInput.setScale(2, RoundingMode.HALF_UP);
        String sNumber = dNumber.format();
        if (!sNumber.contains(',')) sNumber+=',00';
        else 
        {
            String [] items = sNumber.split(',');
            items[1] += '00';
            sNumber = items[0]+','+items[1].left(2);
        }
        return sNumber;
    }


}