<%@ page import="java.sql.*" %>
<%
  String username = "";
  if (session.getAttribute("login") != null) {
    username = session.getAttribute("login").toString();
  }
  else {
    out.println("Invalid session! You must log back into the system.");
    return;
  }

	String outputMsg = "TODO";
	 int employeeID = Integer.parseInt(request.getParameter("employeeID"));
  String firstname = request.getParameter("firstname");
  String lastname = request.getParameter("lastname");
  String address = request.getParameter("address");
  String zipcode = request.getParameter("zipcode");
  String telephone = request.getParameter("telephone");
  String email = request.getParameter("email");
  String password = request.getParameter("password");
  double hourlyRate = "".equals(request.getParameter("hourlyRate")) ? 0 : Double.parseDouble(request.getParameter("hourlyRate"));

	String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	String DB_URL = "jdbc:mysql://localhost:3306/SilkRoad 5.0";
	String USER = "root";
	String PASS = "root";

  Statement stmt = null;
  String sql = null;
	Connection conn = null;
	CallableStatement cs = null;
	try	{
			//Register JDBC driver
			Class.forName(JDBC_DRIVER).newInstance();

			// Open a connection
			conn = java.sql.DriverManager.getConnection(DB_URL, USER, PASS);

      System.out.println("HERE");
			cs = conn.prepareCall("call UpdateEmployeeData(?,?,?,?,?,?,?,?,?)");
   cs.setInt(1, employeeID);
			cs.setString(2, lastname);
			cs.setString(3, firstname);
   cs.setString(4, address);
   cs.setString(5, zipcode);
   cs.setString(6, telephone);
   cs.setString(7, email);
   cs.setString(8, password);
   cs.setDouble(9, hourlyRate);
			cs.execute();

			// TODO. Error handling
	} catch(Exception e) {
		e.printStackTrace();
	}
	finally {
		try {
			conn.close();
		} catch(Exception ee) {};
	}
 response.sendRedirect("EditEmployee.jsp");
%>
