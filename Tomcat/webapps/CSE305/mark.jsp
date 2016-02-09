<%
		String crscode = request.getParameter("crscode");
		String stuid =	""+	session.getValue("login");

			String mysJDBCDriver = "com.mysql.jdbc.Driver"; 
			String mysURL = "jdbc:mysql://sbcstldb.cs.stonybrook.edu:3306/cse305ta"; 
			String mysUserID = "cse305ta"; 
			String mysPassword = "107724115";
			java.sql.Connection conn=null;
			try {
            	Class.forName(mysJDBCDriver).newInstance();
    			java.util.Properties sysprops=System.getProperties();
    			sysprops.put("user",mysUserID);
    			sysprops.put("password",mysPassword);
        
				//connect to the database
            			conn=java.sql.DriverManager.getConnection(mysURL,sysprops);
            			System.out.println("Connected successfully to database using JConnect");
            			java.sql.Statement stmt1=conn.createStatement();
            			            			

									java.util.Enumeration eu = request.getParameterNames();
									while (eu.hasMoreElements())
									{
										String stu =""+ eu.nextElement();
										if (stu.startsWith("stu_"))
										{
											stu = stu.substring(4);
											String score=request.getParameter("stu_"+stu);
											stmt1.executeUpdate("update Transcript set Grade='"+score.trim()+"' where CrsCode='"+crscode.trim()+"' and StudId='"+stu.trim()+"'");
										}
									}
			} catch(Exception e)
			{
				e.printStackTrace();
			}
			finally{
				try{conn.close();}catch(Exception ee){};
			}
%>
Grade Submitted!
<a href="FacultyInformation.jsp"><font color="Blue">Back</font></a>									