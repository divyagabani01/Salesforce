public class StringListTest {
    public static List<String> generateStringList(Integer Counts){
        System.debug('Count =====> '+ Counts);
        List<String> numbers = new List<String>();
	
        for(Integer i = 0; i < counts; i++) {
            numbers.add('Test ' + i);
        }
  		System.debug(numbers);
		return numbers;
    }

    public void getString(Integer counts){
        String[] getData =  generateStringList(counts);
		System.debug('Get Data =====> ' + getData);
    }
}