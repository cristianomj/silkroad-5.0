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
    <title>Searched Course -- Student Registration System</title>

</head>
<body style="text-align: center" bgcolor="#ffff00">
    <span style="font-size: 14pt; font-family: Arial"><strong>Searched Courses According
        to your Preference<br />
        <br />
        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
            <tr>
                <td style="vertical-align: top; width: 11237px; text-align: left; height: 454px;">
                    <span style="font-size: 10pt">These are the searched courses according to your preference.<br />
                        &nbsp;<br />
                    </span><br />

<table border="8" id="TABLE1" onclick="return TABLE1_onclick()">
                    <tr>
                      <td style="width: 84px">
                          <span style="font-size: 10pt">
                          Course Code</span></td>
                      <td style="width: 187px">
                          <span style="font-size: 10pt">Course Name</span></td>
                        <td style="width: 74px">
                            <span style="font-size: 10pt">Department</span></td>
                        <td>
                            <span style="font-size: 10pt">Professor</span></td>
                        <td style="width: 7px">
                            <span style="font-size: 10pt">Oper</span></td>
                    </tr>


<%                    
String strCrsCode = request.getParameter("crscode");
String strCrsName = request.getParameter("crsname");
String strDept = request.getParameter("dept");
String strProfName = request.getParameter("profname");
String strId;

		String mysJDBCDriver = "com.mysql.jdbc.Driver"; 
		String mysURL = "jdbc:mysql://sbcstldb.cs.stonybrook.edu:3306/cse305ta"; 
		String mysUserID = "cse305ta"; 
		String mysPassword = "107724115";
        
        String stuId = ""+session.getValue("login");
  			
  
  
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
            
            			java.sql.Statement stmt=conn.createStatement();
        java.sql.Statement stmt1=conn.createStatement();
									java.sql.Statement stmt2=conn.createStatement();
									java.sql.ResultSet rs,rs1,rs2;  
		if(!strProfName.trim().equals(""))
		 		   		{
		 		   			rs = stmt.executeQuery("select * from Professor " +
		 		   					"WHERE Name = '" + strProfName + "'");

		 		   			while(rs.next())
		 		   			{
		 		   				strId = rs.getString("Id");
		 		   			
			 		   			if(!strCrsCode.equals(""))
			 		   			{
			 		   				if(!strCrsName.equals(""))
			 		   				{
			 		   					if(!strDept.equals(""))
			 		   					{
			 		   						rs1 = stmt1.executeQuery("select * from Course " +
			 		   								"WHERE CrsCode = '" + strCrsCode + "' " +
			 		   								"AND DeptID = '" + strDept + "' " +
			 		   								"AND CrsName = '" + strCrsName + "' " +
			 		   								"AND InsNo = '" + strId + "'");
			 		   					}
			 		   					else
			 		   					{
				 		   					rs1 = stmt1.executeQuery("select * from Course " +
			 		   								"WHERE CrsCode = '" + strCrsCode + "' " +
			 		   								"AND CrsName = '" + strCrsName + "' " +
			 		   								"AND InsNo = '" + strId + "'");
			 		   					}
			 		   				}
		 		   					else // CrsName is null
		 		   					{
			 		   					if(!strDept.equals(""))
			 		   					{
			 		   						rs1 = stmt1.executeQuery("select * from Course " +
			 		   								"WHERE CrsCode = '" + strCrsCode + "' " +
			 		   								"AND DeptID = '" + strDept + "' " +
			 		   								"AND InsNo = '" + strId + "'");
			 		   					}
			 		   					else
			 		   					{
				 		   					rs1 = stmt1.executeQuery("select * from Course " +
			 		   								"WHERE CrsCode = '" + strCrsCode + "' " +
			 		   								"AND InsNo = '" + strId + "'");
			 		   					}
		 		   					}
			 		   			}
			 		   			else  // CrsCode is null
			 		   			{
				 		   			if(!strCrsName.equals(""))
			 		   				{
			 		   					if(!strDept.equals(""))
			 		   					{
			 		   						rs1 = stmt1.executeQuery("select * from Course " +
			 		   								"WHERE DeptID = '" + strDept + "' " +
			 		   								"AND CrsName = '" + strCrsName + "' " +
			 		   								"AND InsNo = '" + strId + "'");
			 		   					}
			 		   					else
			 		   					{
				 		   					rs1 = stmt1.executeQuery("select * from Course " +
			 		   								"WHERE CrsName = '" + strCrsName + "' " +
			 		   								"AND InsNo = '" + strId + "'");
			 		   					}
			 		   				}
		 		   					else // CrsName is null
		 		   					{
			 		   					if(!strDept.equals(""))
			 		   					{
			 		   						System.out.println("select * from Course " +
			 		   								"WHERE DeptID = '" + strDept + "' " +
			 		   								"AND InsNo = '" + strId + "'");
			 		   						rs1 = stmt1.executeQuery("select * from Course " +
			 		   								"WHERE DeptID = '" + strDept + "' " +
			 		   								"AND InsNo = '" + strId + "'");
			 		   					}
			 		   					else
			 		   					{
			 		   						rs1 = stmt1.executeQuery("select * from Course " +
			 		   								"WHERE InsNo = '" + strId + "'");
				 		   				}
		 		   					}		 		   				
			 		   			}
				 		   		while (rs1.next())
			 		   			{
			 							strCrsCode = rs1.getString("CrsCode");
				 		   			
			 		   				strDept = rs1.getString("DeptID");
			 		   				strCrsName = rs1.getString("CrsName");
			 		   				strId = rs1.getString("InsNo");
			 		   				
			 		   				rs2 = stmt2.executeQuery("select * from Professor " +
			   								"WHERE Id = '" + strId + "'");
			 		   				if(rs2.next())
			 		   				{
			 		   					strProfName = rs2.getString("Name");
			 		   				}
%>			 		   				
			 		   				<tr>
                      <td style="width: 84px">
                          <span style="font-size: 10pt"><%=rs1.getString("CrsCode")%></span></td>
                      <td style="width: 187px">
                          <span style="font-size: 10pt"><%=rs1.getString("CrsName")%></span></td>
                        <td style="width: 74px">
                            <span style="font-size: 10pt"><%=rs1.getString("DeptID")%></span></td>
                        <td>
                            <span style="font-size: 10pt"><%=rs2.getString("Name")%></span></td>
                        <td>
                        		<input type=button onclick="javascript:if (confirm('Are you sure that you want to select the course?')==true){window.open('selected.jsp?userid=<%=stuId%>&crscode=<%=rs1.getString("CrsCode")%>','_self');return;" value="Select">
          
                        </td>
                        		
                    </tr>
			 		   				
<%
									}					 		   		
			 		   		}
		 		   		} // end of if strProdID is not null
		 		   		else
		 		   		{
			 		   		if(!strCrsCode.equals(""))
		 		   			{
		 		   				if(!strCrsName.equals(""))
		 		   				{
		 		   					if(!strDept.equals(""))
		 		   					{
		 		   						rs1 = stmt.executeQuery("select * from Course " +
		 		   								"WHERE CrsCode = '" + strCrsCode + "' " +
		 		   								"AND DeptID = '" + strDept + "' " +
		 		   								"AND CrsName = '" + strCrsName + "' ");
		 		   					}
		 		   					else
		 		   					{
			 		   					rs1 = stmt.executeQuery("select * from Course " +
		 		   								"WHERE CrsCode = '" + strCrsCode + "' " +
		 		   								"AND CrsName = '" + strCrsName + "' ");
		 		   					}
		 		   				}
	 		   					else // CrsName is null
	 		   					{
		 		   					if(!strDept.equals(""))
		 		   					{
		 		   						rs1 = stmt.executeQuery("select * from Course " +
		 		   								"WHERE CrsCode = '" + strCrsCode + "' " +
		 		   								"AND DeptID = '" + strDept + "' ");
		 		   					}
		 		   					else
		 		   					{
			 		   					rs1 = stmt.executeQuery("select * from Course " +
		 		   								"WHERE CrsCode = '" + strCrsCode + "' ");
		 		   					}
	 		   					}
		 		   			}
		 		   			else  // CrsCode is null
		 		   			{
			 		   			if(!strCrsName.equals(""))
		 		   				{
		 		   					if(!strDept.equals(""))
		 		   					{
		 		   						rs1 = stmt.executeQuery("select * from Course " +
		 		   								"WHERE DeptID = '" + strDept + "' " +
		 		   								"AND CrsName = '" + strCrsName + "'");
		 		   					}
		 		   					else
		 		   					{
			 		   					rs1 = stmt.executeQuery("select * from Course " +
		 		   								"WHERE CrsName = '" + strCrsName + "'");
		 		   					}
		 		   				}
	 		   					else // CrsName is null
	 		   					{
		 		   					if(!strDept.equals(""))
		 		   					{
		 		   						rs1 = stmt.executeQuery("select * from Course " +
		 		   								"WHERE DeptID = '" + strDept + "'");
		 		   					}
		 		   					else
		 		   					{
			 		   					rs1 = stmt.executeQuery("select * from Course");
		 		   					}
	 		   					}		 		   				
		 		   			}
				 		   	while (rs1.next())
		 		   			{
		 						strCrsCode = rs1.getString("CrsCode");
			 		   			
		 		   				strDept = rs1.getString("DeptID");
		 		   				strCrsName = rs1.getString("CrsName");
		 		   				strId = rs1.getString("InsNo");
		 		   				
		 		   				rs2 = stmt2.executeQuery("select * from Professor " +
		   								"WHERE Id = '" + strId + "'");
		 		   				if(rs2.next())
		 		   				{
		 		   					strProfName = rs2.getString("Name");
		 		   				}
%>
		 		   				<tr>
                      <td style="width: 84px">
                          <span style="font-size: 10pt"><%=rs1.getString("CrsCode")%></span></td>
                      <td style="width: 187px">
                          <span style="font-size: 10pt"><%=rs1.getString("CrsName")%></span></td>
                        <td style="width: 74px">
                            <span style="font-size: 10pt"><%=rs1.getString("DeptID")%></span></td>
                        <td>
                            <span style="font-size: 10pt"><%=rs2.getString("Name")%></span></td>
                        <td>
                        		<input type="button" onclick="javascript:if (confirm('Are you sure that you want to select the course?')==true){window.open('selected.jsp?userid=<%=stuId%>&crscode=<%=strCrsCode%>','_self');}return;" value="Select">
          
                        </td>
                        		
                    </tr>
   <%	 		   				 		   				
		 		   			}
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
                    
                    <input id="Button1" type="button" onclick="javascript:history.back();" value="<--Prev" />
                    <input id="Button2" type="button" onclick="window.open('index.htm','_self');" value="Logout" /><br />
                    
                    
                    <br />
                    <span style="font-size: 8pt">
                        <br />
                        Shang Yang, 10/19/2006, Demo Version<br />
                        Department of Computer Science,<br />
                        SUNY at Stony Brook</span></td>
                <td style="width: 292px; height: 454px; vertical-align: top; text-align: left;">
                    <img src="Bridge.JPG" /></td>
            </tr>
        </table>
    </strong></span>

</body>
</html>
