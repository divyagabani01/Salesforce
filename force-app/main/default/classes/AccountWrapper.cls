public class AccountWrapper {
    public String Name { get; set; }
    public String Phone { get; set; }
    public String BillingStreet { get; set; }
    public String BillingCity { get; set; }
    public String BillingState { get; set; }
    public String BillingPostalCode { get; set; }
    public Integer NumberOfContact { get; set; }
    public Date BirthDate { get; set; } // Corrected field name
    public String IsActive { get; set; } // Clear Boolean indicator
    public String Email { get; set; } // Simplified email field
    public String Type { get; set; }
    public List<FileWrapper> files { get; set; } // Property for files
    
    public class FileWrapper {
        public String Id { get; set; } // Unique identifier for the file
        public String Name { get; set; } // Name of the file
        public Long Size { get; set; } // Size of the file in bytes
        public String Type { get; set; } // MIME type of the file
        public String PreviewUrl { get; set; } // URL for file preview
        public String base64Data {get; set;}
    }
}