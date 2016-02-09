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
    <title>Selected Course -- Student Registration System</title>
<%			String crscode=  request.getParameter("crscode");      %>

</head>
<body style="text-align: center" bgcolor="#ffff00">
    <span style="font-size: 14pt; font-family: Arial"><strong>View and Update the Selected Course<br />
        <br />
        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
            <tr>
                <td style="vertical-align: top; width: 11237px; text-align: left; height: 454px;">
                    <span style="font-size: 10pt">This is the selected course. You can check the student
                        list and update student's GRADE here.<br />
                        <br />
                        <br />
                        &nbsp;<br />
                    </span><br />
					<form action="mark.jsp" method="post">
						<input type="hidden" name=crscode value=<%=crscode%>>
                    <table border="8" id="TABLE1" onclick="return TABLE1_onclick()">
                    <tr>
                      <td style="width: 84px">
                          <span style="font-size: 10pt">
                          Course Code</span></td>
                      <td style="width: 187px">
                          <span style="font-size: 10pt">Course Name</span></td>
                        <td style="width: 74px">
                            <span style="font-size: 10pt">Student ID</span></td>
                        <td>
                            <span style="font-size: 10pt">Student Name</span></td>
                        <td style="width: 7px">
                            <span style="font-size: 10pt">Grade</span></td>
                        </tr>   
<%
			String mysJDBCDriver = "com.mysql.jdbc.Driver"; 
			String mysURL = "jdbc:mysql://sbcstldb.cs.stonybrook.edu:3306/cse305ta"; 
			String mysUserID = "cse305ta"; 
			String mysPassword = "107724115";
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
        
					java.sql.ResultSet rs = stmt1.executeQuery("select Course.CrsCode, Course.CrsName, Student.Id, Student.Name, Transcript.Grade from Course,Student,Transcript where Course.CrsCode=Transcript.CrsCode and Student.Id = Transcript.StudId and Transcript.CrsCode='"+crscode+"'");
 
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
                            <span style="font-size: 10pt"><%=rs.getString(4)%></span></td>
                        <td>
                        		<input type="text" name="stu_<%=rs.getString(3)%>" value=<%=(rs.getString(5).trim().equals("-1"))?"":rs.getString(5)%>>
                        
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
                    <input id="Button1" type="button" onclick="javascript:history.back();" value="<--Prev" />
                    <input id="Button2" type="submit" value="Submit" />
                    <input id="Button3" type="button" onclick="window.open('index.htm','_self');" value="Logout" /><br />
                    <span style="font-size: 8pt">
                        <br />
                        Shang Yang, 10/19/2006, Demo Version<br />
                        Department of Computer Science,<br />
                        SUNY at Stony Brook</span></td>
                <td style="width: 292px; height: 454px; vertical-align: top; text-align: left;">
                    <img src="Bridge.JPG" /></td>
            </tr>
                  </form>
        </table>
    </strong></span>

</body>
</html>
