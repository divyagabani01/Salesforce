public class Animal {
	public static final DECIMAL PI_VALUE = 3.14;

    public void person(Integer pId, String name){
        System.debug('id'+ pId);
        System.debug('name'+ name);
		// If I need to use any private method so we need to call this method any public method as par requirement
		String str = sum('Dharti','Kankotiya');
        System.debug(str);
    }
	
	// Below methods called method overloading
    public Integer sum(Integer a,Integer b,Integer c){
        return a+b+c;
    }

 	public Integer sum(Integer a,Integer b){
        return a+b;
    }

	// We can't use this method outside 'Animal' class 
	private String sum(String str,String str1){
        return str + ' ' + str1;
    }
}