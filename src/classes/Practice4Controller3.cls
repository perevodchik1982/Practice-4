public class Practice4Controller3 {
    public Product_Table__c prod;
    public String prodId;
    public String email {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public Integer bikeQuantity {get; set;}
    public Double amount {get; set;}
    public Id contId; 
    public boolean showButton {get; set;}
   
    public Practice4Controller3() { 
        if (ApexPages.currentPage().getParameters().get('Id') != null) {
            prodId = ApexPages.currentPage().getParameters().get('Id');
            prod = [SELECT Name, Image_Url__c, Product_description__c,
                	Unit_price__c, Units_available__c,
                    Warehouse__r.Name
                	FROM Product_Table__c WHERE Id = : prodId];
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Product query error'));
        }
        bikeQuantity = 1;
        amount = prod.Unit_price__c;
        email = '';
        firstName = '';
        lastName = '';
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
     
	public PageReference Practice4Page2() {
        PageReference pageRef = new PageReference(Page.Practice4Page2.getUrl());
        pageRef.getParameters().put('id', prodId);
        pageRef.setRedirect(true);
		return pageRef;
    }
    
    public void getCont() {
         if (email != null) {
            List<Contact> queryCont = [SELECT FirstName, LastName FROM Contact WHERE Email =: email LIMIT 1];
             if (!queryCont.isEmpty()) {
                contId = queryCont[0].Id;
                firstName = queryCont[0].FirstName;        
            	lastName = queryCont[0].LastName;
             }        
            checkQuantity();
         }  
    }
    
    public void checkQuantity() {
        amount = prod.Unit_price__c * bikeQuantity;
        if (prod.Units_available__c >= bikeQuantity &&
           	email.length() > 0 && 
            lastName.length() > 0 &&
           	bikeQuantity > 0) { 
            showButton = true;
        }
    }
    
    public PageReference bikeOrder() {
        if (contId == null) {
            Contact newCont = new Contact(
            LastName = lastName,
            Email = email
            );
            if (firstName.length() > 0) {
                newCont.FirstName = firstName;
            }
            try {
            insert newCont;
            } catch(DmlException e) { 
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDmlMessage(0)));
                return null;
            }
            contId = newCont.Id;
        }
        Order_table__c newOrder = new Order_table__c(
        	Product__c = prod.Id,
            Units__c = bikeQuantity,
            Contact__c = contId,
            Order_Amount__c = amount
        );
        try {
            prod.Units_Available__c -= bikeQuantity;
        	update prod;
        	insert newOrder;
        	PageReference pageRef = new PageReference(Page.Practice4Page1.getUrl());
        	pageRef.getParameters().put('info', Label.orderSubmitted);
        	pageRef.setRedirect(true);
			return pageRef;       
        } catch(DmlException e) { 
            PageReference pageRef = new PageReference(Page.Practice4Page1.getUrl());
        	pageRef.getParameters().put('info', Label.wentWrong + e.getMessage());
        	pageRef.setRedirect(true);
			return pageRef;                 
        }        
    }
}