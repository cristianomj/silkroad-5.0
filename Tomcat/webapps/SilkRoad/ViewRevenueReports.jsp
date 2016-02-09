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

ResultSet revenueListRes = null;

ResultSet sellerListRes = null;
ResultSet itemListRes = null;
ResultSet itemTypeListRes = null;


String JDBC_DRIVER = "com.mysql.jdbc.Driver";
String DB_URL = "jdbc:mysql://localhost:3306/SilkRoad 5.0";
String USER = "root";
String PASS = "root";

String searchType = request.getParameter("searchType");
String searchValue = request.getParameter("searchValue");
if (searchValue!=null) {
   searchValue = searchValue.replaceAll("_", " ");
}
String col1 ="";
String col2 ="";
String col3 ="Revenue";

Statement stmt = null;
String sql = null;
Connection conn = null;
CallableStatement cs = null;
try	{
 //Register JDBC driver
 Class.forName(JDBC_DRIVER).newInstance();

 // Open a connection
 conn = java.sql.DriverManager.getConnection(DB_URL, USER, PASS);

 cs = conn.prepareCall("call GetAllSellers()");
 cs.execute();
 sellerListRes = cs.getResultSet();

 cs = conn.prepareCall("call GetAllItems()");
 cs.execute();
 itemListRes = cs.getResultSet();

 cs = conn.prepareCall("call GetAllItems()");
 cs.execute();
 itemTypeListRes = cs.getResultSet();




 System.out.println("HERE");
 switch (searchType) {
   case "all":
   // cs = conn.prepareCall("call GetRevenueBySeller(?)");
   // cs.setString(1, "");
   // cs.execute();
   // revenueListRes = cs.getResultSet();
   col1 = "Name";
   col2 = "Items Sold";
   break;

   case "seller":
   cs = conn.prepareCall("call GetRevenueBySeller(?)");
   cs.setString(1, searchValue);
   cs.execute();
   revenueListRes = cs.getResultSet();
   col1 = "Username";
   col2 = "Items Sold";
   break;

   case "itemType":
   cs = conn.prepareCall("call GetRevenueByItemType(?)");
   cs.setString(1, searchValue);
   cs.execute();
   revenueListRes = cs.getResultSet();
   col1 = "Type";
   col2 = "Copies Sold";
   break;

   case "itemName":
   cs = conn.prepareCall("call GetRevenueByItemName(?)");
   cs.setString(1, searchValue);
   cs.execute();
   revenueListRes = cs.getResultSet();
   col1 = "Item Name";
   col2 = "Copies Sold";
   break;
 }



 // TODO. Error handling

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
         <script src="js/editCustomer.js"></script>
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
            <script>
              function ViewSalesRefresh(selection) {
               var searchType = selection.name;
               var searchValue = selection.value;
               searchValue = searchValue.replace(" ", "_");
               window.location = "ViewRevenueReports.jsp?searchType="+searchType+"&searchValue="+searchValue;
              }
            </script>
            <body class="auctionHouseBody">
             <h4 class="auctionTableHeader">Sales Search</h4>
             <div class="container-fluid">
               <div class="row">

                 <div class="col-lg-4">
                      <h2>Search by Seller</h2>
                      <select onchange="ViewSalesRefresh(this)"  style="width:30%;" class="form-control" name="seller" id="seller">
                       <optgroup style="font-size:28px;">
                        <option></option>
                         <% while (sellerListRes.next()) { %>
                      <option>	<%= sellerListRes.getString(1)%></option>
                       <% } %>
                       </optgroup>
                    </select>
                 </div>

                 <div class="col-lg-4">
                  <h2>Search by Item name</h2>
                  <select onchange="ViewSalesRefresh(this)"  style="width:30%;" class="form-control" name="itemName" id="itemName">
                   <optgroup style="font-size:28px;">
                    <option></option>
                    <% while (itemListRes.next()) { %>
                  <option>	<%= itemListRes.getString(1)%></option>
                  <% } %>
                   </optgroup>
                </select>
                 </div>

                 <div class="col-lg-4">
                  <h2>Search by Item type</h2>
                  <select onchange="ViewSalesRefresh(this)"  style="width:30%;" class="form-control" name="itemType" id="itemType">
                   <optgroup style="font-size:28px;">
                    <option></option>
                    <% while (itemTypeListRes.next()) { %>
                  <option><%= itemTypeListRes.getString(2)%></option>
                    <% } %>
                   </optgroup>
                </select>

                 </div>
               </div>
             </div> <br><hr>
             <table id ="bestSellersTable" class="table table-striped table-bordered dt-responsive nowrap auctionHouseTable">
              <thead>
               <tr>
                <th><%=col1%></th>
                <th><%=col2%></th>
                <th><%=col3%></th>
               </tr>
              </thead>
              <tbody>
               <% while(revenueListRes.next()) { %>
               <tr>
                <td>
                 <%= revenueListRes.getString(1)%>
                </td>
                <td>
                 <%= revenueListRes.getString(2) %>
                </td>
                <td>
                 <%= revenueListRes.getDouble(3)%>
                </td>
               </tr>
               <% } %>
              </tbody>
             </table>
            </body>
           </html>

           <%
          } catch(Exception e) {
           e.printStackTrace();
          }
          finally {
           try {
            conn.close();
           } catch(Exception ee) {};
          }
          %>
