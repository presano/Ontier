/**
 * @author        J. Rubén Olivera
 * @company       Deloitte
 * @date          22/04/2021
 * @description   Clase Selector AccountTeamMember
 * @layer         Selector
*/
public without sharing class GOT_AccountTeamMemberSelector extends fflib_SObjectSelector
{
 
    public GOT_AccountTeamMemberSelector() 
    { 
        super(false, // Do not include FieldSet fields
          false, // Do not enforce Object level security
          false); // Do not enforce Field level security 
    }
    
    public GOT_AccountTeamMemberSelector(Boolean includeFieldSetFields) 
    {
        super(includeFieldSetFields);
    }
    
    public GOT_AccountTeamMemberSelector(Boolean includeFieldSetFields, Boolean enforceObjectLevel, Boolean includeFieldSecurity) 
    { 
        super(includeFieldSetFields, // Do not include FieldSet fields
          enforceObjectLevel, // Do not enforce Object level security
          includeFieldSecurity); // Do not enforce Field level security 
    }
    
    public Schema.SObjectType getSObjectType() 
    {
        return AccountTeamMember.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() 
    {
        return new List<Schema.SObjectField> 
        {
            AccountTeamMember.Id,
            AccountTeamMember.AccountId,
            AccountTeamMember.UserId,
            AccountTeamMember.GOT_ProductRef__c,
            AccountTeamMember.GOT_AreaPick__c
        };
    }

    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          20/04/2021
    * @description   Método que busca Account Team Member por su Id
    * @param         setOfAccTeamMemberId - Set<Id> - Set con los Id a buscar
	* @return		 listOfAccTeamMember - List<AccountTeamMember> - Lista de AccountTeamMember
	*/
    public List<AccountTeamMember> findById(Set<Id> setOfAccTeamMemberId)
    {
        List<AccountTeamMember> listOfAccTeamMember = (List<AccountTeamMember>) Database.query(
            newQueryFactory().
            setCondition('Id IN :setOfAccTeamMemberId').
            toSOQL()
        );
        return listOfAccTeamMember;
    }


    /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          20/04/2021
    * @description   Método que busca Time Reports por User y Dates
    * @param         setOfUserId - Set<Id> - Set con los Id a buscar
	* @return		 listOfAccTeamMember - List<AccountTeamMember> - Lista de AccountTeamMember
	*/
    public List<AccountTeamMember> findByUserId(Set<Id> setOfUserId)
    {
        List<AccountTeamMember> listOfAccTeamMember = (List<AccountTeamMember>) Database.query(
            newQueryFactory().
            setCondition('UserId IN :setOfUserId').
            toSOQL()
        );
        return listOfAccTeamMember;
    }

     /**
	* @author        Teresa Santos
    * @company       Deloitte
    * @date          20/04/2021
    * @description   Método que busca Time Reports por User y Dates
    * @param         setOfUserId - Set<Id> - Set con los Id a buscar
	* @return		 listOfAccTeamMember - List<AccountTeamMember> - Lista de AccountTeamMember
	*/
    public List<AccountTeamMember> findByUserIdAndAccountRT(Set<Id> setOfUserId, Id accountRTId)
    {
        List<AccountTeamMember> listOfAccTeamMember = (List<AccountTeamMember>) Database.query(
            newQueryFactory().
            setCondition('UserId IN :setOfUserId AND Account.RecordTypeId = :accountRTId').
            toSOQL()
        );
        return listOfAccTeamMember;
    }
}