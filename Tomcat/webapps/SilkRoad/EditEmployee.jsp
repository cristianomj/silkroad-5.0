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

  ResultSet employeeListRes = null;

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
  <div id="editEmployeeModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header myModal auctionTableHeader">Edit Employee</div>
            <div class="modal-body">
                <input type="hidden" id="employeeID">
                <label class = "control-label" for="Txt">Lastname</label>
                <div class = "controls regControl input-symbol-dollar">
                    <input type="text" class="form-control" name="lastname" id="lastname" >
                </div>
                <label class = "control-label" for="Txt">Firstname</label>
                <div class = "controls regControl input-symbol-dollar">
                    <input type="text" class="form-control" name="firstname" id="firstname">
                </div>

                <label class = "control-label" for="Txt">Address</label>
                <div class = "controls regControl input-symbol-dollar">
                    <input type="text" class="form-control" name="address" id="address">
                </div>

                <label class = "control-label" for="Txt">Zipcode</label>
                <div class = "controls regControl input-symbol-dollar">
                    <input type="text" class="form-control" name="zipcode" id="zipcode">
                </div>

                <label class = "control-label" for="Txt">Telephone</label>
                <div class = "controls regControl input-symbol-dollar">
                    <input type="text" class="form-control" name="telephone" id="telephone">
                </div>

                <label class = "control-label" for="Txt">Email</label>
                <div class = "controls regControl input-symbol-dollar">
                    <input type="text" class="form-control" name="email" id="email">
                </div>

                <label class = "control-label" for="Txt">Password</label>
                <div class = "controls regControl input-symbol-dollar">
                    <input type="text" class="form-control" name="password" id="password">
                </div>

                <label class = "control-label" for="Txt">Hourly Rate</label>
                <div class = "controls regControl input-symbol-dollar">
                    <input type="text" class="form-control" name="hourlyRate" id="hourlyRate">
                </div>
            </div>
            <div class="modal-footer">
                <button id="placeBidBtn" class="btn btn-primary" data-dismiss="modal" onclick="editEmployeeData(employeeID, lastname.value,
                 firstname.value, address.value, zipcode.value, telephone.value, email.value, password.value, hourlyRate.value)" aria-hidden="true">Update</button>
            </div>
          </form>
        </div>
    </div>
</div> <!-- bidModal -->
<div id="deleteEmployeeModal" class="modal fade">
  <div class="modal-dialog">
      <div class="modal-content">
          <div class="modal-header myModal auctionTableHeader">Delete Employee</div>
          <div class="modal-body">
              <input type="hidden" id="employeeID">
              <label class = "control-label" for="Txt">Are you sure you want to delete </label>
              <label id="toBeDeleted"></label>
          </div>
          <div class="modal-footer">
              <button id="placeBidBtn" class="btn btn-warning btn-block" data-dismiss="modal" onclick="deleteEmployee(employeeID)" aria-hidden="true">Update</button>
          </div>
        </form>
      </div>
  </div>
</div> <!-- bidModal -->
<body class="auctionHouseBody">
  <h4 class="auctionTableHeader">All Employees</h4>
  <% cs = conn.prepareCall("call GetAllEmployeeData()");
    cs.execute();
    // TODO. Error handling
    cs.getMoreResults();
    employeeListRes = cs.getResultSet();
  %>
  <div class="container" id="employeeTable">
    <table id ="bestSellersTable" class="table table-striped table-bordered dt-responsive nowrap auctionHouseTable">
      <thead>
        <tr>
          <th>Lastname</th>
          <th>Firstname</th>
          <th>Address</th>
          <th>Zip code</th>
          <th>Telephone</th>
          <th>Email</th>
          <th>Username</th>
          <th>Password</th>
          <th>Hourly Rate</th>
        </tr>
      </thead>
      <tbody>
        <% while(employeeListRes.next()) { %>
        <tr>
          <td>
            <%= employeeListRes.getString(1)%>
          </td>
          <td>
            <%= employeeListRes.getString(2)%>
          </td>
          <td>
            <%= employeeListRes.getString(3)%>
          </td>
          <td>
            <%= employeeListRes.getString(4)%>
          </td>
          <td>
            <%= employeeListRes.getString(5)%>
          </td>
          <td>
            <%= employeeListRes.getString(6)%>
          </td>
          <td>
            <%= employeeListRes.getString(7)%>
          </td>
          <td>
            <%= employeeListRes.getString(8)%>
          </td>
          <td>
            <%= employeeListRes.getString(9)%>
          </td>
          <td width = "1%">
             <select onchange="employeeDataAction(this,'<%=employeeListRes.getString("Lastname")%>', '<%=employeeListRes.getString("Firstname")%>',
             '<%=employeeListRes.getString("Address")%>','<%=employeeListRes.getString("ZipCode")%>','<%=employeeListRes.getString("Telephone")%>',
             '<%=employeeListRes.getString("Email")%>', '<%=employeeListRes.getString("Password")%>', '<%=employeeListRes.getString("HourlyRate")%>')">
                <option value=""></option>
                <option value='<%=employeeListRes.getInt("EmployeeID")%>'>
                Edit</option>
             </select>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</body>
</html>
<%
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
