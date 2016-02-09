//STEP 1. Import required packages

import java.sql.*;

public class JDBCTest {
    // JDBC driver name and database URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/silkroad 5.0";

    //  Database credentials
    static final String USER = "root";
    static final String PASS = "<yourpassword>";

    public static void main(String[] args) {
        Connection conn = null;
        Statement stmt = null;
        try{
            //STEP 2: Register JDBC driver
            Class.forName(JDBC_DRIVER);

            // STEP 3: Open a connection
            System.out.println("Connecting to database...");
            conn = DriverManager.getConnection(DB_URL,USER,PASS);

            // Create CallableStatement
            CallableStatement cs = conn.prepareCall("call PostAuction(1,2,now(),4,5,6,7)");

            // Execute the call statement and expecting multiple result sets
            boolean isResultSet = cs.execute();

            // First ResultSet object will contain one row, two columns: Status, ReturnMsg
            if (!isResultSet) {
                System.out.println("The first result is not a ResultSet.");
                return;
            }

            // STEP 4: Execute a query
            ResultSet res = cs.getResultSet();

            // STEP 5: Extract the status and the return msg
            while(res.next()){
                //Retrieve by column name
                int status = res.getInt(1);
                String returnMsg = res.getString(2);

                // Display values. If status != 0 there was an error
                if (status != 0) {
                    System.out.println("Error: " + returnMsg);
                    // Do error handling
                }
            }
            res.close();

            // Move to the next result if one exists.
            // A procedure will have an extra result if we're getting data back
            // But some procedures don't return anything so they won't have a second result set
            isResultSet = cs.getMoreResults();
            if (!isResultSet) {
                System.out.println("The next result is not a ResultSet.");
                return;
            }

            // Second ResultSet object
            System.out.println("Second result set:");
            res = cs.getResultSet();
            while (res.next()) {
                System.out.println("something");
            }
            res.close();

            //STEP 6: Clean-up environment
            cs.close();
            conn.close();
        } catch(SQLException se) {
            //Handle errors for JDBC
            String str = se.getMessage();
            System.out.println(str);
        } catch(Exception e) {
            //Handle errors for Class.forName
            e.printStackTrace();
        } finally {
            //finally block used to close resources
            try {
                if(stmt!=null)
                    stmt.close();
            } catch(SQLException se2) {
            }// nothing we can do
            try{
                if(conn!=null)
                    conn.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }//end try
        System.out.println("Goodbye!");
    }//end main
}//end FirstExample