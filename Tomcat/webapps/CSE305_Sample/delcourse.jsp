<%
		String userid = request.getParameter("userid");
		String crscode = request.getParameter("crscode");
     	String mysJDBCDriver = "com.mysql.jdbc.Driver"; 
     	String mysURL = "jdbc:mysql://sbcstldb.cs.stonybrook.edu:3306/cse305ta"; 
     	String mysUserID = "cse305ta"; 
    	String mysPassword = "107724115";

/*    	
	if ((username!=null) &&(userpasswd!=null))
	{
		if (username.trim().equals("") || userpasswd.trim().equals(""))
		{
			response.sendRedirect("index.htm");
		}
		else
		{
*/
			// code start here
			java.sql.Connection conn=null;
			try 
			{
            	Class.forName(mysJDBCDriver).newInstance();
    			java.util.Properties sysprops=System.getProperties();
    			sysprops.put("user",mysUserID);
    			sysprops.put("password",mysPassword);
        
				//connect to the database
            			conn=java.sql.DriverManager.getConnection(mysURL,sysprops);
            			System.out.println("Connected successfully to database using JConnect");
            
            			java.sql.Statement stmt1=conn.createStatement();
							stmt1.executeUpdate("delete from Transcript where CrsCode='"+crscode+"' and StudId='"+userid+"'");
			} catch(Exception e)
			{
				e.printStackTrace();
				out.print(e.toString());
			}
			finally{
			
				try{conn.close();}catch(Exception ee){};
			}
/*
	}
*/
%>

Course Deleted!
<a href="StudentInformation.jsp"><font color="Blue">Back</font></a>