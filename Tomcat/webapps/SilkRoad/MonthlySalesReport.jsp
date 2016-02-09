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
  ResultSet montlySalesRes = null;
   ResultSet totalRevenueRes = null;
  double totalRevenue = 0;

  String month = request.getParameter("month");




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


%>


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
    <script src="js/editEmployee.js"></script>
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
      </div>
      <!-- navbar-header -->
      <!-- Collect the nav links, forms, and other content for toggling -->
      <div class="myNavbar">
        <ul class="nav">
          <li class="floatLeft"><a href="ManagerInformation.jsp">Home</a></li>
          <li class="dropdown navbar-right" style="padding-left:125px;">
            <a data-target="#collapseHelp" data-toggle="collapse">Help<span class="caret"></span></a>
            <ul>
              <div id="collapseHelp" class="dropdown-menu">
                <li><a href="javascript:showEmployeeScreenHelp()">Screens</a></li>
                <br>
                <li><a href="javascript:showAuctionHelp()">Auctions</a></li>
                <br>
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
        </ul>
        <!-- .nav -->
      </div>
      <!-- .myNavbar -->
    </div>
    <!-- .container-fluid -->
  </nav>
<body class="auctionHouseBody">
  <h4 class="auctionTableHeader">See Sales  from</h4>
  <div class="container">
   <script>
     function MonthlySalesRefresh(selection) {
      var month = selection.value;
      window.location = "MonthlySalesReport.jsp?month="+month;
     }
   </script>
   <script>
   $(function() {
    document.getElementById('month').selectedIndex = '<%=month%>' - 1;
 		});
   </script>
    <label class = "control-label regLabel" for="month"></label>
    <center><div class = "controls regControl">

        <select onchange="MonthlySalesRefresh(this)"  style="width:50%;" class="form-control" name="month" id="month">
         <optgroup style="font-size:28px;">
        <option value="01">January</option>
        <option value="02">February</option>
        <option value="03">March</option>
        <option value="04">April</option>
        <option value="05">May</option>
        <option value="06">June</option>
        <option value="07">July</option>
        <option value="08">August</option>
        <option value="09">September</option>
        <option value="10">October</option>
        <option value="11">November</option>
        <option value="12">December</option>
         </optgroup>
      </select>
<br><hr>
    </div>
   </center>
  </div>
  <%
    if (!month.equals("00")) {
    cs = conn.prepareCall("call GetMonthlySales(?)");
    cs.setInt(1, Integer.parseInt(month));
    cs.execute();
    // TODO. Error handling
    totalRevenueRes = cs.getResultSet();
    while (totalRevenueRes.next()){
     totalRevenue = totalRevenueRes.getDouble(1);
    }
    cs.getMoreResults();
    montlySalesRes = cs.getResultSet();

  %>
  <div class="container" id="monthlySalesTable">
   <table id ="bestSellersTable" class="table table-striped table-bordered dt-responsive nowrap auctionHouseTable">
    <thead>
     <tr>
      <th>Buyer</th>
      <th>Seller</th>
      <th>Price</th>
      <th>Date</th>
      <th>Item</th>
      <th>Auction ID</th>
     </tr>
    </thead>
    <tbody>
     <% while(montlySalesRes.next()) { %>
     <tr>
      <td>
       <%= montlySalesRes.getString("Buyer")%>
      </td>
      <td>
       <%= montlySalesRes.getString("Seller") %>
      </td>
      <td>
       <%= montlySalesRes.getDouble("Price")%>
      </td>
      <td>
       <%= montlySalesRes.getString("Date")%>
      </td>
      <td>
       <%= montlySalesRes.getString("ItemName")%>
      </td>
      <td>
       <%= montlySalesRes.getInt("AuctionID")%>
      </td>
     </tr>
     <% } %>
    </tbody>
   </table>
   <div id="container">
   <p style="font-size:30px; color:white;">Total Revenue: <%=totalRevenue%><p>
   </div>
  </div>
</body>
</html>
<%
}
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


<%-- <select onchange="employeeDataAction(this,'<%=employeeListRes.getString("Lastname")%>', '<%=employeeListRes.getString("Firstname")%>',
'<%=employeeListRes.getString("Address").substring(0, employeeListRes.getString("Address").length()-3)%>','<%=employeeListRes.getString("ZipCode")%>','<%=employeeListRes.getString("Telephone")%>',
'<%=employeeListRes.getString("Email")%>', '<%=employeeListRes.getString("Password")%>', '<%=employeeListRes.getString("HourlyRate")%>',
'<%=employeeListRes.getString("Address").substring(employeeListRes.getString("Address").length()-2)%>')">
   <option value=""></option>
   <option value='<%=employeeListRes.getInt("EmployeeID")%>'>
   Edit</option>
</select> --%>
