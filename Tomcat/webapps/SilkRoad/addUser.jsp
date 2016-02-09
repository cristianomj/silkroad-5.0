<%@ page import="java.sql.*" %>
<%
		String username = request.getParameter("username");
		String outputMsg = "There was an unexpected server error.";
		String ssn = request.getParameter("ssn");
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String userPassword = request.getParameter("password");
		String address = request.getParameter("street") + "," + request.getParameter("city") +
										 "," + request.getParameter("state");
		String email = request.getParameter("email");
		String telephone = request.getParameter("telephone");
		String zipcode = request.getParameter("zipcode");

		String JDBC_DRIVER = "com.mysql.jdbc.Driver";
		String DB_URL = "jdbc:mysql://localhost:3306/SilkRoad 5.0";
		String USER = "root";
		String PASS = "root";

		// Code starts here
		Connection conn = null;
		CallableStatement cs = null;
		try	{
				//Register JDBC driver
        Class.forName(JDBC_DRIVER).newInstance();

				// Open a connection
  			conn = java.sql.DriverManager.getConnection(DB_URL, USER, PASS);

				// Add either an employee or a customer to the database
        if (request.getParameter("target").trim().equals("customer")) {
						cs = conn.prepareCall("call AddCustomer(?,?,?,?,?,?,?,?,?,?)");
						String ccn = request.getParameter("ccn");
						cs.setString(1, ssn);
						cs.setString(2, firstName);
						cs.setString(3, lastName);
						cs.setString(4, address);
						cs.setString(5, zipcode);
						cs.setString(6, telephone);
						cs.setString(7, email);
						cs.setString(8, username);
						cs.setString(9, userPassword);
						cs.setString(10, ccn);
				}
				else { // add an employee
					  cs = conn.prepareCall("call AddEmployee(?,?,?,?,?,?,?,?,?,?,?)");
						int level = request.getParameter("levelRadio").equals("Manager") ? 1 : 0;
						double hourlyRate = "".equals(request.getParameter("hourlyRate")) ? 0 : Double.parseDouble(request.getParameter("hourlyRate"));
						cs.setString(1, ssn);
						cs.setString(2, firstName);
						cs.setString(3, lastName);
						cs.setString(4, address);
						cs.setString(5, zipcode);
						cs.setString(6, telephone);
						cs.setString(7, email);
						cs.setString(8, username);
						cs.setString(9, userPassword);
						cs.setDouble(10, hourlyRate);
						cs.setInt(11, level);
				}
				cs.execute();
				ResultSet res = cs.getResultSet();
				while(res.next()){
						// Retrieve by column name
						int status = res.getInt("Status");
						String returnMsg = res.getString("ReturnMsg");

						// Display values. If status != 0 there was an error
						if (status != 0) {
								outputMsg = returnMsg;
						}
						else {
							outputMsg = username + " was successfully added. Welcome.";
						}
				}
				res.close();
			} catch(Exception e) {
					e.printStackTrace();
					out.print(e.toString());
			}
			finally{
				try {
					if (cs != null) {
						cs.close();
					}
					if (conn != null) {
						conn.close();
					}
				} catch (Exception e) {};
			}
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Silk Road 5.0</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Our own custom css -->
    <link href="css/stylesheet.css" rel="stylesheet" type="text/css">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/jquery-1.11.3.min.js"></script>
    <script src="js/jquery.validate.js"></script>
    <script src="js/pattern.js"></script>
    <script src="js/script.js"></script>

  </head>
    <body class="homePageBody">
      <div class="container">
        <div class = "jumbotron transparentJumbo">
          <h1>Silk Road 5.0</h1>
          <p><%= outputMsg %></p>
					<input id="Button2" class="btn btn-default" type="button" value="Go Back" onclick="javascript:history.back()" />
					<a class="btn btn-default" href="index.html" role="button">Home</a>
        </div>
			</div>
		</body>
	</html>
