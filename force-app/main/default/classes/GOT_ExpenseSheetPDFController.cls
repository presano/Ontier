/**
 * @author        J. Rubén Olivera
 * @company       Deloitte
 * @date          26/04/2021
 * @description   Clase Controller para GOT_ExpenseSheetVF 
 * @layer         Controller
*/
public without sharing class GOT_ExpenseSheetPDFController 
{
    private final GOT_ExpenseSheet__c expenseSheet;

    public GOT_ExpenseSheetPDFController(ApexPages.StandardController stdController) 
    {
        this.expenseSheet = (GOT_ExpenseSheet__c) stdController.getRecord();
    }

    public List<String> getListOfOntierUserOffice()
    {
        List<String> listOfOffice = new List<String>();
        GOT_AccountTeamMemberSelector accTeamMemberSelector = new GOT_AccountTeamMemberSelector();
        List<AccountTeamMember> listOfAccTeamMember = accTeamMemberSelector.findByUserIdAndAccountRT(new Set<Id>{expenseSheet.GOT_UserRef__c}, GOT_AccountSelector.ONTIER);
        if (listOfAccTeamMember.isEmpty()) return listOfOffice;

        Set<Id> setOfAccountId = new Set<Id>();
        for (AccountTeamMember accTeamMember : listOfAccTeamMember)
        {
            setOfAccountId.add(accTeamMember.AccountId);
        }

        GOT_AccountSelector accountSelector = new GOT_AccountSelector();
        List<Account> listOfAccount = accountSelector.findById(setOfAccountId);
        for (Account acc : listOfAccount)
        {
            listOfOffice.add(acc.Name);
        }
        return listOfOffice;
    }

    public String getBrandLogoUrl()
    {
        AppDefinition appDef = [SELECT Id, DeveloperName, LogoUrl FROM AppDefinition WHERE DeveloperName='GOT_OntierApp' LIMIT 1];
        return appDef.LogoUrl;
    }
}