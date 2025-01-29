public class AddressValidationUtil {
    public static void validateField(SObject record, String fieldName) {
        String value = (String) record.get(fieldName);
        System.debug('value: ' + value); // Use single quotes for better readability
        String FirstLetter = value.subString(0,1);
        Pattern allowedPattern = Pattern.compile('^[^#!%$^<~()*>".\']*(?:[^#!%$^<~()>".\'][^#!%$^`<~()>"\']*)?$');
        Pattern consecutiveSpecialCharacters = Pattern.compile('^(?!.*[!@#\\$%\\^&\\*()_+={}\\[\\]|\\\\:;\"\'<>,.?/`~-]{2,}).*$');
        
        Pattern firstCharPattern = Pattern.compile('^[a-zA-Z0-9].*'); // Only alphanumeric for first character
        if (value != null) {
            List<String> errors = new List<String>();
            // Check if the first character is alphanumeric
            if (!firstCharPattern.matcher(FirstLetter).matches()) {
                record.addError(fieldName, 'The first character must be alphanumeric.');
            }else if (!allowedPattern.matcher(value).matches()) {
                record.addError(fieldName, 'Invalid characters are not allowed.');
            } else {
                if( (!consecutiveSpecialCharacters.matcher(value).matches())){
                    record.addError(fieldName, 'Consecutive special characters are not allowed.');                    
                }
                
            }
        }
    }


}