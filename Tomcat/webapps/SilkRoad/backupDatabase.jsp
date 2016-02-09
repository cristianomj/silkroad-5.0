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

      String table_name = "Person";
      String backup_file  = "D:/Files/Projects/SilkRoad-5.0/Tomcat/webapps/SilkRoad/Backups/Person.sql";

      stmt = conn.createStatement();
      sql = "SELECT * INTO OUTFILE '" + backup_file + "' FROM " + table_name;
      stmt.executeQuery(sql);

      table_name = "Sales";
      backup_file  = "D:/Files/Projects/SilkRoad-5.0/Tomcat/webapps/SilkRoad/Backups/Sales.sql";
      sql = "SELECT * INTO OUTFILE '" + backup_file + "' FROM " + table_name;
      stmt.executeQuery(sql);

      table_name = "Post";
      backup_file  = "D:/Files/Projects/SilkRoad-5.0/Tomcat/webapps/SilkRoad/Backups/Post.sql";
      sql = "SELECT * INTO OUTFILE '" + backup_file + "' FROM " + table_name;
      stmt.executeQuery(sql);

      table_name = "Item";
      backup_file  = "D:/Files/Projects/SilkRoad-5.0/Tomcat/webapps/SilkRoad/Backups/Item.sql";
      sql = "SELECT * INTO OUTFILE '" + backup_file + "' FROM " + table_name;
      stmt.executeQuery(sql);

      table_name = "Employee";
      backup_file  = "D:/Files/Projects/SilkRoad-5.0/Tomcat/webapps/SilkRoad/Backups/Employee.sql";
      sql = "SELECT * INTO OUTFILE '" + backup_file + "' FROM " + table_name;
      stmt.executeQuery(sql);

      table_name = "Customer";
      backup_file  = "D:/Files/Projects/SilkRoad-5.0/Tomcat/webapps/SilkRoad/Backups/Customer.sql";
      sql = "SELECT * INTO OUTFILE '" + backup_file + "' FROM " + table_name;
      stmt.executeQuery(sql);

      table_name = "Bid";
      backup_file  = "D:/Files/Projects/SilkRoad-5.0/Tomcat/webapps/SilkRoad/Backups/Bid.sql";
      sql = "SELECT * INTO OUTFILE '" + backup_file + "' FROM " + table_name;
      stmt.executeQuery(sql);

      table_name = "Auction";
      backup_file  = "D:/Files/Projects/SilkRoad-5.0/Tomcat/webapps/SilkRoad/Backups/Auction.sql";
      sql = "SELECT * INTO OUTFILE '" + backup_file + "' FROM " + table_name;
      stmt.executeQuery(sql);

			// TODO. Error handling
	} catch(Exception e) {
		e.printStackTrace();
	}
	finally {
		try {
			conn.close();
		} catch(Exception ee) {};
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
          <p>As long as the Backups folder had no contents, the database has been successfully exported.</p>
					<input id="Button2" class="btn btn-default" type="button" value="Go Back" onclick="javascript:history.back()" />
        </div>
			</div>
		</body>
	</html>
