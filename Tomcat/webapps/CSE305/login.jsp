<%
	if((request.getParameter("action")!=null)&&	(request.getParameter("action").trim().equals("logout")))
	{
		session.putValue("login","");
		response.sendRedirect("/");
		return;
	}
		String username = request.getParameter("username");
		String userpasswd = request.getParameter("userpasswd");
     	String mysJDBCDriver = "com.mysql.jdbc.Driver"; 
     	String mysURL = "jdbc:mysql://sbcstldb.cs.stonybrook.edu:3306/cse305ta"; 
     	String mysUserID = "cse305ta"; 
    	String mysPassword = "107724115";
    	
	session.putValue("login","");
	if ((username!=null) &&(userpasswd!=null))
	{
		if (username.trim().equals("") || userpasswd.trim().equals(""))
		{
			response.sendRedirect("index.htm");
		}
		else
		{
			// code start here
			java.sql.Connection conn=null;
			try {
		            	Class.forName(mysJDBCDriver).newInstance();
            			java.util.Properties sysprops=System.getProperties();
            			sysprops.put("user",mysUserID);
            			sysprops.put("password",mysPassword);
        
				//connect to the database
            			conn=java.sql.DriverManager.getConnection(mysURL,sysprops);
            			System.out.println("Connected successfully to database using JConnect");
            
            			conn.setAutoCommit(false);
            			java.sql.Statement stmt1=conn.createStatement();
				java.sql.ResultSet rs = stmt1.executeQuery(" select * from Student where Id='"+username+"' and Pswd='"+userpasswd+"'");
				if (rs.next())
				{
					// login success
					session.putValue("login",username);
					response.sendRedirect("StudentInformation.jsp");
				}
				else
				{
					rs = stmt1.executeQuery(" select * from Professor where Id='"+username+"' and Pswd='"+userpasswd+"'");
					if(rs.next())
					{
						session.putValue("login", username);
						response.sendRedirect("FacultyInformation.jsp");
					}
						
					else
					{
						// username or password mistake
						response.sendRedirect("passMistake.jsp");
					}
				}
			} catch(Exception e)
			{
				e.printStackTrace();
			}
			finally{
				try{conn.close();}catch(Exception ee){};
			}
		}
	}
%>