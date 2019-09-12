public class Practice4Controller2 {
    public Product_Table__c prod;
    public String prodId;
          
	public Practice4Controller2() {      
        if (ApexPages.currentPage().getParameters().get('Id') != null) {
            prodId = ApexPages.currentPage().getParameters().get('Id');
        } else {        
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Product query error'));
        }
    }
    
    public PageReference Practice4Page1() {
        PageReference pageRef = new PageReference(Page.Practice4Page1.getUrl());
        pageRef.getParameters().put('id', prodId);
		pageRef.setRedirect(true);
		return pageRef;
    }
    
    public Product_Table__c getProd() {
        if (prodId != null) {
            return [SELECT Name, Image_Url__c, Product_description__c, 
                	Unit_price__c, Units_available__c,
                    Warehouse__r.Name
                	FROM Product_Table__c WHERE Id = : prodId];
        } else {
            return null;
        }
    }
    
   	public PageReference Practice4Page3() {
        PageReference pageRef = new PageReference(Page.Practice4Page3.getUrl());
        pageRef.getParameters().put('id', prodId);
		pageRef.setRedirect(true);
		return pageRef;
    } 
      
}