/** 
* @author			J. Rubén Olivera   
* @company          Deloitte
* @date             22/02/2021
* @description      Clase Selector para objeto User
* @layer			Selector
*/
public without sharing class GOT_UserSelector extends fflib_SObjectSelector 
{
    public GOT_UserSelector() 
    { 
        super(false, // Do not include FieldSet fields
          false, // Do not enforce Object level security
          false); // Do not enforce Field level security 
    }
    
    public GOT_UserSelector(Boolean includeFieldSetFields) 
    {
        super(includeFieldSetFields);
    }
    
    public GOT_UserSelector(Boolean includeFieldSetFields, Boolean enforceObjectLevel, Boolean includeFieldSecurity)
    { 
        super(includeFieldSetFields, // Do not include FieldSet fields
          enforceObjectLevel, // Do not enforce Object level security
          includeFieldSecurity); // Do not enforce Field level security 
    }
    
    public Schema.SObjectType getSObjectType() 
    {
        return User.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() 
    {
        return new List<Schema.SObjectField> 
        {
            User.Id,
            User.IsActive,
            User.ProfileId,
            User.UserRoleId,
            User.FirstName,
            User.LastName,
            User.Username,
            User.Email,
            User.LanguageLocaleKey,
            User.GOT_YearBillableHours__c,
            User.GOT_OntierUserIdAuto__c,
            User.GOT_OntierProfilePick__c,
            User.GOT_OfficePick__c,
            User.GOT_IsCurrentUserAuto__c,
            User.GOT_CECOAuto__c,
            User.GOT_AreaPick__c,
            User.GOT_CorrectionFactor__c,
            user.Name
        };
    }

    /**
	* @author        J.Rubén Olivera
    * @company       Deloitte
    * @date          22/02/2021
    * @description   Método que busca usuarios activos por Id
    * @param         setOfUserId - Set<Id> - Set con los Id a buscar
	* @return		 listOfUser - List<User> - Lista de User encontrados
	*/
    public List<User> findActiveById(Set<Id> setOfUserId)
    {
        List<User> listOfUser = (List<User>) Database.query(
            newQueryFactory().
            setCondition('Id IN :setOfUserId AND IsActive = true').
            toSOQL()
        );
        return listOfUser;
    }

    

    /**
	* @author        J.Rubén Olivera
    * @company       Deloitte
    * @date          22/02/2021
    * @description   Método que busca usuarios activos por Id
    * @param         setOfUserId - Set<Id> - Set con los Id a buscar
	* @return		 listOfUser - List<User> - Lista de User encontrados
	*/
    public List<User> findById(Set<Id> setOfUserId)
    {
        List<User> listOfUser = (List<User>) Database.query(
            newQueryFactory().
            setCondition('Id IN :setOfUserId').
            toSOQL()
        );
        return listOfUser;
    }

    /**
	* @author        J.Rubén Olivera
    * @company       Deloitte
    * @date          22/02/2021
    * @description   Método que busca usuarios activos por oficina y área
    * @param         setOfOffice - Oficinas a buscar
    * @param         setOArea - Areas a buscar
	* @return		 listOfUser - List<User> - Lista de User encontrados
	*/
    public List<User> findActiveByOfficeAndArea(Set<String> setOfOffice, Set<String> setOfArea)
    {
        List<User> listOfUser = (List<User>) Database.query(
            newQueryFactory().
            setCondition('GOT_OfficePick__c IN :setOfOffice AND GOT_AreaPick__c IN :setOfArea').
            toSOQL()
        );
        return listOfUser;
    }
    
}