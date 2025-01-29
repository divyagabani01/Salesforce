public class Laptops {
	public String companyName;
    public Laptops(String companyName){
        System.debug('CompanyName in constructor ======> ' + companyName);
        this.companyName = companyName;
		// printCompanyName();
    }
    
    public void printCompanyName(){
        System.debug('Company name withing printCompanyName method is ====> ' + companyName);
    }
}