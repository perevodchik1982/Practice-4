public class Practice4Controller1 {
    public List<Product_Table__c> products;
    public String prodId {get; set;}
    
    public Practice4Controller1() {
        if (ApexPages.currentPage().getParameters().get('info') != null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,
               ApexPages.currentPage().getParameters().get('info')));
        }
    }
    
    public List<Product_Table__c> getProducts() {
        return [SELECT Name, Image_Url__c, Product_description__c, 
                Unit_price__c, Units_available__c     
                FROM Product_Table__c LIMIT 100];
    }
    
    public PageReference Practice4Page2() {
        PageReference pageRef = new PageReference(Page.Practice4Page2.getUrl());
        pageRef.getParameters().put('id', prodId);
		pageRef.setRedirect(true);
		return pageRef;
    }
    
    public PageReference Practice4Page3() {
        PageReference pageRef = new PageReference(Page.Practice4Page3.getUrl());
        pageRef.getParameters().put('id', prodId);
		pageRef.setRedirect(true);
		return pageRef;
    }
}