public class Constants {
	public static final DECIMAL PI_VALUE = 3.14;
    
    public static final STRING COUNTRY_VALUE = 'INDIA';

    public void print(){
           // Define a list of integers
        List<Integer> numbers = new List<Integer>{1, 2, 3, 4, 5};
        
        // Use a traditional for loop to iterate over the list and double each number
        for (Integer i = 0; i < numbers.size(); i++) {
            // Access and modify each element in the list
            Decimal num = PI_VALUE + i;
            System.debug('Doubled Number: ' + numbers[i] + 'Num : ' + num);
			System.debug(PI_VALUE);
        }
    }
     
}