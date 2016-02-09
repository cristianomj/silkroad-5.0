<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
	String item = request.getParameter("item");
  String openingTimeStr = request.getParameter("openingTime");
  int duration = Integer.parseInt(request.getParameter("duration"));
  double openingBid = Double.parseDouble(request.getParameter("openingBid"));
  String reserveStr = request.getParameter("reserve");
  double reserve = 0;
  if (reserveStr != null && !reserveStr.isEmpty()) {
    reserve = Double.parseDouble(reserveStr);
  }

  SimpleDateFormat dt1 = new SimpleDateFormat("MMMM dd, yyyy", java.util.Locale.US);
  java.sql.Date openingTime = new java.sql.Date(dt1.parse(openingTimeStr).getTime());

	String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	String DB_URL = "jdbc:mysql://localhost:3306/SilkRoad 5.0";
	String USER = "root";
	String PASS = "root";

  Statement stmt = null;
  String sql = null;
	Connection conn = null;
	CallableStatement cs = null;
  ResultSet res = null;
	try	{
			//Register JDBC driver
			Class.forName(JDBC_DRIVER).newInstance();

			// Open a connection
			conn = java.sql.DriverManager.getConnection(DB_URL, USER, PASS);

			cs = conn.prepareCall("call PostAuction(?,?,?,?,?,?)");
			cs.setString(1, item);
			cs.setString(2, username);
      cs.setDate(3, openingTime);
      cs.setDouble(4, duration);
      cs.setDouble(5, openingBid);
      cs.setDouble(6, reserve);
			cs.execute();

      res = cs.getResultSet();
      while(res.next()){
          // Retrieve by column name
          int status = res.getInt("Status");
          String returnMsg = res.getString("ReturnMsg");

          // Display values. If status != 0 there was an error
          if (status != 0) {
              outputMsg = returnMsg;
          }
          else {
            outputMsg = "Your auction was successfully placed!";
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
          </div>
  			</div>
  		</body>
  	</html>
