/*
	Created by: Gaurav Trivedi
	Notes:
		- extension for the attachPDFToAccount.page Visualforce page which is accessible from a custom link on the Account detail page
		- generates a PDF file and attaches it to the Account
		gdjsgaghfdkaghfiahfiahgiuuiyuujjjjkhklhklhkhdkghs
*/
public class attachPDFToAccount {
	
	private final Account a; //Account object
	
	//constructor
	public attachPDFToAccount(ApexPages.StandardController standardPageController) {
		a = [SELECT id, Name FROM Account WHERE id='0013600000H7EFl'];
        /*a = (Account)standardPageController.getRecord(); //instantiate the Account object for the current record
        system.debug('Account : '+a);*/
	}
	
	//method called from the Visualforce's action attribute
	public PageReference attachPDF() {
        
        Attachment theAttachment = new Attachment();
        Blob body;
        PageReference generatePage = 
            new PageReference('/apex/attachPDFToAccount?id='+a.id);
        try {
            body = generatePage.getContent();
        }
        catch(Exception ex) {
            body = Blob.valueOf(ex.getMessage());
        }
        theAttachment.Body = body;
        theAttachment.Name = 'templateName' + ' on ' + String.valueOf(System.now());
        theAttachment.ContentType = 'application/msword';
        theAttachment.IsPrivate = false;
        theAttachment.ParentId = '0013600000H7EFl';
        
        // Insert our lone Attachment
        try {
            insert theAttachment;
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
        }
        
        
		/*//generate and attach the PDF document
		PageReference pdfPage = Page.attachPDFToAccount; //create a page reference to our pdfDemo Visualforce page, which was created from the post http://www.interactiveties.com/blog/2015/render-visualforce-pdf.php
		//Blob pdfBlob = pdfPage.getContentAsPDF(); //get the output of the page, as displayed to a user in a browser
		System.debug('dskhiafh : '+pdfPage.getContent());
        //Attachment attach = new Attachment(parentId = a.Id, Name = 'pdfAttachmentDemo.pdf', body = pdfBlob); //create the attachment object
		//insert attach; //insert the attachment*/
		//redirect the user
		PageReference pageWhereWeWantToGo = new ApexPages.StandardController(a).view(); //we want to redirect the User back to the Account detail page
		pageWhereWeWantToGo.setRedirect(true); //indicate that the redirect should be performed on the client side
		return pageWhereWeWantToGo; //send the User on their way
        
	}

}