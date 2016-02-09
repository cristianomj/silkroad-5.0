<%@ page import="java.sql.*" %>
<%
	if((request.getParameter("action") != null) &&	(request.getParameter("action").trim().equals("logout"))) {
			session.putValue("login", "");
			response.sendRedirect("/");
			return;
	}
	String outputMsg = "TODO";
	String userType = "";
	String username = request.getParameter("username");
	String userPassword = request.getParameter("password");
	int employeeLevel = -1;

	String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	String DB_URL = "jdbc:mysql://localhost:3306/SilkRoad 5.0";
	String USER = "root";
	String PASS = "root";

	session.putValue("login", "");

	// Code starts here
	Connection conn = null;
	CallableStatement cs = null;
	try	{
			//Register JDBC driver
			Class.forName(JDBC_DRIVER).newInstance();

			// Open a connection
			conn = java.sql.DriverManager.getConnection(DB_URL, USER, PASS);

			cs = conn.prepareCall("call ValidateUser(?,?)");
			cs.setString(1, username);
			cs.setString(2, userPassword);
			cs.execute();

			// Extract the status and the return msg
			ResultSet res = cs.getResultSet();
			while (res.next()){
					// Retrieve by column name
					int status = res.getInt(1);
					String returnMsg = res.getString(2);

					// Display values. If status != 0 there was an error
					if (status != 0) {
						if (status == 1) {
							// Username or password mistake
							response.sendRedirect("passMistake.jsp");
						}
						else {
							// Unexpected error. TODO better error handling here
							outputMsg = returnMsg;
							return;
						}
					}
			}
			res.close();

			// Move to the next result set which tells us if the user is a Customer/Employee
			cs.getMoreResults();
      res = cs.getResultSet();
      while (res.next()) {
          userType = res.getString(1);
					employeeLevel = res.getInt(2);
      }
      res.close();

			// At this point we have a login success
			session.putValue("login", username);

			// Bring the user to the appropriate page
			if (userType.equals("Customer")) {
				response.sendRedirect("CustomerSearch.jsp");
			}
			else if (employeeLevel == 1){
				response.sendRedirect("ManagerInformation.jsp");
			} else if (employeeLevel == 0) {
					response.sendRedirect("EmployeeInformation.jsp");
			} else {
				response.sendRedirect("failedLogin.jsp");
			}
	} catch(Exception e) {
		e.printStackTrace();
	}
	finally {
		try {
			conn.close();
		} catch(Exception ee) {};
	}
%>
