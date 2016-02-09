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
	final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	final String DB_URL = "jdbc:mysql://localhost:3306/SilkRoad 5.0";
	final String USER = "root";
	final String PASS = "root";

	// Code starts here
	String sql = null;
	Connection conn = null;
	CallableStatement cs = null;
	Statement	stmt = null;

	// Will hold all of the item types
	ResultSet itemTypeRes = null;

	// Will hold all of the seller usernames
	ResultSet sellerRes = null;

	// Will hold the best sellers
	ResultSet bestSellersRes = null;

	// Will hold the personalized item suggestions
	ResultSet itemSuggestionRes = null;

	try	{
			//Register JDBC driver
			Class.forName(JDBC_DRIVER).newInstance();

			// Open a connection
		  conn = java.sql.DriverManager.getConnection(DB_URL, USER, PASS);
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
		<%-- <script src="js/jquery.countdown.min.js"></script> --%>

    <script src="js/pattern.js"></script>
    <script src="js/script.js"></script>
		<script src="js/auctionTableScript.js"></script>
		<script>
		$(function() {
		    searchByType('all');
		});
		</script>
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
		<% cs = conn.prepareCall("call GetBestSellerList()");
			cs.execute();
			// TODO. Error handling
			cs.getMoreResults();
			bestSellersRes = cs.getResultSet();
		%>
		<div id="bestSellersModal" class="modal fade">
		  <div class="modal-dialog">
		      <div class="modal-content">
		          <div class="modal-header myModal auctionTableHeader">Our Best Sellers!</div>
		          <div class="modal-body">
		            <table id ="bestSellersTable" class="table table-striped table-bordered dt-responsive nowrap auctionHouseTable">
		              <thead>
		                <tr>
		                  <th>User</th>
		                  <th>Items Sold</th>
		                </tr>
		              </thead>
		              <tbody>
		                <% while(bestSellersRes.next()) { %>
		                <tr>
		                  <td>
		                    <%= bestSellersRes.getString("Username")%>
		                  </td>
		                  <td>
		                    <%= bestSellersRes.getInt("ItemsSold") %>
		                  </td>
		                </tr>
		                <% } %>
		              </tbody>
		            </table>
		          </div>
		      </div>
		  </div>
	</div> <!-- bestSellersModal -->
	<% cs = conn.prepareCall("call GetAllItems()");
		cs.execute();
		itemSuggestionRes = cs.getResultSet();
	%>
	<div id="itemSuggestionsModal" class="modal fade">
		<div class="modal-dialog">
				<div class="modal-content">
						<div class="modal-header myModal auctionTableHeader">Your Personalized Item Suggestions</div>
						<div class="modal-body">
							<table id ="itemSuggestionsTable" class="table table-striped table-bordered dt-responsive nowrap auctionHouseTable">
								<thead>
									<tr>
										<th>Name</th>
										<th>Type</th>
										<th>Year</th>
										<th>Description</th>
										<th>Number of Copies</th>
									</tr>
								</thead>
								<tbody>
									<% while(itemSuggestionRes.next()) { %>
									<tr>
										<td>
											<%= itemSuggestionRes.getString("Name")%>
										</td>
										<td>
											<%= itemSuggestionRes.getString("Type") %>
										</td>
										<td>
											<% String year = itemSuggestionRes.getString("Year").split("-")[0]; %>
											<%= year %>
										</td>
										<td>
											<% String description = itemSuggestionRes.getString("Description") == null ? "No description" : itemSuggestionRes.getString("Description"); %>
											<%= description %>
										</td>
										<td>
											<%= itemSuggestionRes.getInt("NumCopies") %>
										</td>
									</tr>
									<% } %>
								</tbody>
							</table>
						</div>
				</div>
		</div>
</div> <!-- itemSuggestionsModal -->
	<div class="borderSidebar">
		<form name="myForm" id="customerSearchForm">
				<div class="form-group greenShadowText">
					<label class = "control-label regLabel" for="itemType1">Search By Type:</label>
					<div class = "controls regControl">
							<select id="itemType" class="form-control">
							<option>-- Show all --</option> <!-- TODO. Better empty option? -->
							<%
							stmt = conn.createStatement();
							sql = "select distinct I.Type from Item I";
							itemTypeRes = stmt.executeQuery(sql);
							while(itemTypeRes.next()) {
							%>
							<option value=
								"<% itemTypeRes.getString(1); %>" >
								<%= itemTypeRes.getString(1)%>
							</option>
							<% } %>
						</select>
					</div>
				</div> <!-- searchByType -->
				<div class="form-group greenShadowText">
					<div class = "controls regControl">
							<input name="searchByTypeBtn" class="btn btn-default" type="button" onclick="searchByType('all')" value="Search"/>
					</div>
				</div>
			<div class="form-group greenShadowText">
				<label class = "control-label regLabel" for="itemName">Search By Name:</label>
				<div class = "controls regControl">
						<input type="text" class="form-control" id="itemName1" placeholder="Item Name">
				</div>
			</div>
			<div class="form-group greenShadowText">
				<div class = "controls regControl">
						<input type="text" class="form-control" id="itemName2" placeholder="Item Name">
				</div>
			</div>
			<div class="form-group greenShadowText">
				<div class = "controls regControl">
						<input type="text" class="form-control" id="itemName3" placeholder="Item Name">
				</div>
			</div>
			<div class="form-group greenShadowText">
				<div class = "controls regControl">
						<input name="searchByNameBtn" class="btn btn-default" type="button" onclick="searchByName('all')" value="Search"/>
				</div>
			</div>
			<div class="form-group greenShadowText">
				<label class = "control-label regLabel" for="sellerUsername">Search By Seller:</label>
				<div class = "controls regControl">
						<select id="sellerUsername" class="form-control">
						<option>-- Show all --</option>
						<%
							cs = conn.prepareCall("call GetAllSellers()");
	    				cs.execute();

		    			// Extract the status and the return msg
		    			sellerRes = cs.getResultSet();
							while(sellerRes.next()) {
						%>
						<option>
							<%= sellerRes.getString(1)%>
						</option>
						<% }
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						try {
							bestSellersRes.close();
							itemTypeRes.close();
							sellerRes.close();
							itemSuggestionRes.close();
							conn.close();
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					%>
					</select>
				</div>
			</div> <!-- searchBySeller -->
			<div class="form-group greenShadowText">
				<div class = "controls regControl">
						<input name="searchBySellerBtn" class="btn btn-default" type="button" onclick="searchBySeller('all')" value="Search"/>
				</div>
			</div>
	</form> <!-- myForm -->
	</div> <!-- borderSidebar -->
  <div class="container auctionTable">
    <div>
			<h4 class="auctionTableHeader">ALL AUCTIONS</h4>
			<div id="auctionData">
      	<!-- filled with data returned from the ajax call -->
			</div>
    </div>
</div> <!-- .container .auctionTable-->
	</body>
	</html>
