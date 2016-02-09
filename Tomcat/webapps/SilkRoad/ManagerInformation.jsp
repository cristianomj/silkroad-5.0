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
final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
final String DB_URL = "jdbc:mysql://localhost:3306/SilkRoad 5.0";
final String USER = "root";
final String PASS = "root";

// Code starts here
String sql = null;
Connection conn = null;
CallableStatement cs = null;
Statement	stmt = null;

try	{
  //Register JDBC driver
  Class.forName(JDBC_DRIVER).newInstance();

  // Open a connection
  conn = java.sql.DriverManager.getConnection(DB_URL, USER, PASS);
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

            <%-- <link href="css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css"> --%>
            <link href="css/responsive.bootstrap.min.css" rel="stylesheet" type="text/css">
              <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.5/css/bootstrap-dialog.min.css" rel="stylesheet" type="text/css" />

              <!-- Our own custom css -->
              <link href="css/stylesheet.css" rel="stylesheet" type="text/css">

                <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
                <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
                <!--[if lt IE 9]>
                <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
                <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
                <![endif]-->
                <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
                <script src="js/jquery-1.11.3.min.js"></script>
                <script src="js/jquery.validate.js"></script>
                <%-- <script src="js/jquery.dataTables.js"></script> --%>

                <!-- Include all compiled plugins (below), or include individual files as needed -->
                <script src="js/bootstrap.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.5/js/bootstrap-dialog.min.js"></script>

                <script src="js/pattern.js"></script>
                <script src="js/script.js"></script>

              </head>
              <nav class="navbar">
                <div class="container-fluid">
                  <!-- Brand and toggle get grouped for better mobile display -->
                  <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                      <span class="sr-only">Toggle navigation</span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                    </button>
                  </div> <!-- navbar-header -->

                  <!-- Collect the nav links, forms, and other content for toggling -->
                  <div class="myNavbar">
                    <ul class="nav">
                     <li class="active floatLeft">
             					<a class="open_nav" href="#">Home<span class="sr-only">(current)</span></a>
             				</li>
                      <%-- <li class="open_nav"><a href="ManagerInformation.jsp">Home</a></li> --%>
                      <li class="dropdown navbar-right" style="padding-left:125px;">
                        <a data-target="#collapseHelp" data-toggle="collapse">Help<span class="caret"></span></a>
                        <ul>
                          <div id="collapseHelp" class="dropdown-menu">
                            <li><a href="javascript:showEmployeeScreenHelp()">Screens</a></li><br>
                            <li><a href="javascript:showAuctionHelp()">Auctions</a></li><br>
                          </div>
                        </ul>
                      </li>
                      <li class="dropdown navbar-right" style="padding-left:200px;">
                        <a data-target="#collapseMenu" data-toggle="collapse" >Menu<span class="caret"></span></a>
                        <ul>
                          <div id="collapseMenu" class="dropdown-menu">
                            <li><a href="backupDatabase.jsp">Backup Database</a></li><br>
                          </div>
                        </ul>
                      </li>
                    </ul> <!-- .nav -->
                  </div> <!-- .myNavbar -->
                </div> <!-- .container-fluid -->
              </nav>
              <body class="auctionHouseBody">
                <h2 align="center" style="color:white; text-shadow: 0 0 4px black, 0 0 4px black, 0 0 4px black, 0 0 4px black;">Manager Actions</h2> <br><br>
                <div class="container-fluid">
                  <div class="row">
                    <div class="col-lg-6">
                        <a href="EditEmployee.jsp" type="button" style="font-size : 28px;" class="btn btn-default btn-block">Edit Employee Data</a><hr>
                        <a href="MonthlySalesReport.jsp?month=00" type="button" style="font-size : 28px;" class="btn btn-primary btn-block">Monthly Sales Data</a><hr>
                        <a href="GetAllItemsTEST.jsp" type="button" style="font-size : 28px;" class="btn btn-success btn-block">See All Items</a><hr>
                        <a href="ViewSales.jsp?searchType=all" type="button" style="font-size : 28px;" class="btn btn-info btn-block"   >View Sales</a>
                    </div>
                    <div class="col-lg-6">
                        <a href="ViewRevenueReports.jsp?searchType=all" type="button" style="font-size : 28px;" class="btn btn-default btn-block">Revenue Reports</a><hr>
                        <a href="EmployeeRevenue.jsp" type="button" style="font-size : 28px;" class="btn btn-primary btn-block">Employee Revenue</a><hr>
                        <a href="BestSellerView_Customer.jsp" type="button" style="font-size : 28px;" class="btn btn-success btn-block">Top Selling Customers</a><hr>
                        <a href="BestSellerView_Item.jsp" type="button" style="font-size : 28px;" class="btn btn-info btn-block"   >Best Selling Items</a>
                    </div>
                  </div>
                </div>
              </body>
            </html>
