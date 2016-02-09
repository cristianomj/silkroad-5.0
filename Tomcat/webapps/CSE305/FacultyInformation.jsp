<%
if (request.getProtocol().compareTo("HTTP/1.0")==0)
      response.setHeader("Pragma","no-cache");
if (request.getProtocol().compareTo("HTTP/1.1")==0)
      response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires",0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>Your Course Information -- Student Registration System</title>

</head>
<body style="text-align: center" bgcolor="#ffff00">
    <span style="font-size: 14pt; font-family: Arial"><strong>Hello, Professor. Your ID is
        <%=session.getValue("login")%>. Here is Your Course Information.<br />
        <br />
        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
            <tr>
                <td style="vertical-align: top; width: 11237px; text-align: left; height: 454px;">
                    <span style="font-size: 10pt">These are the courses you are teaching in this semester,
                        you can check the information of the corresponding course by select the "View" button to check more information.<br />
                        <br />
                    </span><br />
                    
                    <table border="8" id="TABLE1" onclick="return TABLE1_onclick()">
                    <tr>
                      <td style="width: 84px">
                          <span style="font-size: 10pt">
                          Course Code</span></td>
                      <td style="width: 74px">
                            <span style="font-size: 10pt">Department</span></td>
                      
                      
                      <td style="width: 187px">
                          <span style="font-size: 10pt">Course Name</span></td>
                        
                         <td style="width: 7px">
                            <span style="font-size: 10pt">Oper</span></td>
                    </tr>   
<%
		String crscode=request.getParameter("crscode");
        
		String mysJDBCDriver = "com.mysql.jdbc.Driver"; 
		String mysURL = "jdbc:mysql://sbcstldb.cs.stonybrook.edu:3306/cse305ta"; 
		String mysUserID = "cse305ta"; 
		String mysPassword = "107724115";
        
        String profId = ""+session.getValue("login");
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
        
					java.sql.ResultSet rs = stmt1.executeQuery("select * from Course where Course.InsNo='"+profId+"'");
      	  while(rs.next())
        	{
%>
                    <tr>
                      <td style="width: 84px">
                          <span style="font-size: 10pt"><%=rs.getString(1)%></span></td>
                      <td style="width: 187px">
                          <span style="font-size: 10pt"><%=rs.getString(2)%></span></td>
                        <td style="width: 74px">
                            <span style="font-size: 10pt"><%=rs.getString(3)%></span></td>
                        <td>
                        	<input type=button  onclick="javascript:window.open('FacultyDetailedCourseInfo.jsp?crscode=<%=rs.getString(1).trim()%>','_self');return;" value="View and Set Transcript">
        
                        </td>
                        		
                    </tr>
<%      		
        	}
  			} catch(Exception e)
			{
				e.printStackTrace();
				out.print(e.toString());
			}
			finally{
			
				try{conn.close();}catch(Exception ee){};
			}

  %>
  					</table>
                    
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <input id="Button1" type="button" value="Logout" onclick="window.open('index.htm','_self');" /><br />
                    <span style="font-size: 8pt">
                        <br />
                        Shang Yang, 10/19/2006, Demo Version<br />
                        Department of Computer Science,<br />
                        SUNY at Stony Brook</span></td>
                <td style="width: 292px; height: 454px; vertical-align: top; text-align: left;">
                    <img src="Hospital.JPG" /></td>
            </tr>
        </table>
    </strong></span>

</body>
</html>