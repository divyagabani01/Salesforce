public class ExampleForPolymorephicQuery {
    public static void SampleForPolymorephicQuery(){
            // Define a list to hold the results
            List<String> results = new List<String>();
            
            // Define the query string
           /* String queryString = 
                'SELECT TYPEOF What ' +
                'WHEN Account THEN Phone ' +
                'ELSE Name ' +
                'END ' +
                'FROM Event ' +
                'WHERE CreatedById IN (SELECT CreatedById FROM Case)';*/
            
			// Define the query string
            String queryString = 
                'SELECT TYPEOF What ' +
                'WHEN Account THEN Id, Phone, LastModifiedDate ' +
                'WHEN Opportunity THEN Id, Name ' +
                'END ' +
                'FROM Task';
            // Execute the query
            List<Task> events = Database.query(queryString);
            
            // Iterate through the results
            for (Task evt : events) {
                // Use TYPEOF to determine the correct field to access
				System.debug('evt.What instanceof Account' + evt.What);
                if (evt.What instanceof Account) {
                    // Cast the What field to Account and get the Phone
                    results.add(((Account)evt.What).Phone);
                } else {
                    // Get the Name field for other objects
                    results.add(evt.What.Name);
                }
            }
            
            // Optionally, output the results for debugging
            System.debug(results);

    }
}