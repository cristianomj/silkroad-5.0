<%
		String Id = request.getParameter("Id");
		String Name = request.getParameter("Name");
		String Password1 = request.getParameter("Password1");
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
           if (request.getParameter("target").trim().equals("student"))
           {
							stmt1.executeUpdate("insert into Student values('"+Id+"','"+Password1+"','"+Name+"','"+request.getParameter("status")+"')");
//							out.print("insert into Student values('"+Id+"','"+Password1+"','"+Name+"','"+request.getParameter("status")+"')");
							stmt1.close();
						}
					else
           {
							stmt1.executeUpdate("insert into Professor values('"+Id+"','"+Password1+"','"+Name+"','"+request.getParameter("DepID")+"')");
//							out.print("insert into Professor values('"+Id+"','"+Password1+"','"+Name+"','"+request.getParameter("DepID")+"')");;
							stmt1.close();
						}
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

User Added!
<a href="index.htm"><font color="Blue">Home</font></a>