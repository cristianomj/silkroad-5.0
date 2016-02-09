<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
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
      ArrayList usages = new ArrayList();
    	// Code starts here
      StringTokenizer st = new StringTokenizer(request.getParameter("usage"),"|");
      while(st.hasMoreTokens()) {
        usages.add(st.nextToken());
      }
    	String sql = null;
    	Connection conn = null;
    	CallableStatement cs = null;
      ResultSet res = null;

      // Will hold the bid histories
    	ResultSet bidHistoryRes = null;

      // Will hold the winner of the auction
      ResultSet winnerRes = null;

      boolean isCustomer = true;

      ResultSet userTypeRes = null;
    	try	{

    			//Register JDBC driver
    			Class.forName(JDBC_DRIVER).newInstance();

    			// Open a connection
    		  conn = java.sql.DriverManager.getConnection(DB_URL, USER, PASS);

          cs = conn.prepareCall("call GetUserType(?)");
          cs.setString(1, username);
          cs.execute();

    			// Extract the status and the return msg
    			userTypeRes = cs.getResultSet();
          // TODO. Error handling
          while (userTypeRes.next()) {
            isCustomer = userTypeRes.getString(1).equalsIgnoreCase("Customer");
          }

          // Set to 1 if we want to return auctions even if they're completed
          int returnAllAuctions = usages.contains("all") ? 1 : 0;

          // We're either filtering by itemname or itemtype
          if (usages.contains("name")) {
            String name1 = request.getParameter("name1");
            String name2 = request.getParameter("name2");
            String name3 = request.getParameter("name3");
      			cs = conn.prepareCall("call GetItemsByKeywords(?, ?, ?, ?, ?)");
            cs.setString(1, name1);
            cs.setString(2, name2);
            cs.setString(3, name3);
            cs.setString(4, usages.contains("user") ? username : "");
            cs.setInt(5, returnAllAuctions);
          } else if (usages.contains("type")) {
            String type = request.getParameter("type");
      			cs = conn.prepareCall("call GetItemsByType(?, ?, ?)");
            cs.setString(1, type);
            cs.setString(2, usages.contains("user") ? username : "");
            cs.setInt(3, returnAllAuctions);
          } else if (usages.contains("seller")) {
            String sellerUsername = request.getParameter("seller");
            cs = conn.prepareCall("call GetItemsBySeller(?, ?, ?)");
            cs.setString(1, sellerUsername);
            cs.setString(2, usages.contains("user") ? username : "");
            cs.setInt(3, returnAllAuctions);
          }

    			cs.execute();

    			// Extract the status and the return msg
    			res = cs.getResultSet();
          // TODO. Error handling
          if (cs.getMoreResults()) {
              res = cs.getResultSet();
          }
      %>
      <script type="javascript/text" id="runscript">
      // TODO. Get this to just use auctionTableScript
      $(function() {
          // Find arg must match the closest tag after <td colspan="3">
          $("td[colspan=5]").find("div").hide();
          $("#auctionDataTable").click(function(event) {
              event.stopPropagation();
              var target = $(event.target);
              var plus = "<span class=\"glyphicon glyphicon-plus\" aria-hidden=\"true\"></span>";
              var minus = "<span class=\"glyphicon glyphicon-minus\" aria-hidden=\"true\"></span>";
              // Without this check we run the risk of editing the tables on non + and -
              if (target.html().contains("+") || target.html().contains("-")) {
                  if (target.closest("td").attr("colspan") > 1 ) {
                      slideUp();
                      target.closest("tr").prev().find("td:first").html(minus);
                  } else {
                      // Find arg must match the same that we hid
                      target.closest("tr").next().find("div").slideToggle();
                      var path = target.closest("tr").find("td:first").find("button:first");
                      if (path.html().contains(plus)) {
                          path.html(minus);
                      }
                      else {
                          path.html(plus);
                      }
                 }
              }
          });
          // TODO. Maybe add a counter for the time left column?
          // function startCountdown(date) {
          //  $("#getting-started").countdown(date, function(event) {
          //     $(this).text(
          //       event.strftime('%D days %H:%M:%S')
          //     );
          //   });
          // }
      });
      </script>

	  <style>
		.expired { color: red; }
		.active  { color: green; }
	  </style>

      <!-- modal which gets input from user to place a bid -->
      <div id="bidModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header myModal auctionTableHeader">Place Bid</div>
                <div class="modal-body">
                    <input type="hidden" id="auctionID">
                    <label class = "control-label" for="bidTxt">Enter bid amount:</label>
                    <div class = "controls regControl input-symbol-dollar">
                        <span>$</span>
            						<input type="text" class="form-control" name="bidTxt" id="bidTxt">
            				</div>
                </div>
                <div class="modal-footer">
                    <button id="placeBidBtn" class="btn btn-primary" data-dismiss="modal" onclick="placeBid(auctionID, bidTxt.value)" aria-hidden="true">OK</button>
                </div>
              </form>
            </div>
        </div>
    </div> <!-- bidModal -->
    <!-- modal which gets input from user to place a bid -->
    <div id="itemDetailsModal" class="modal fade">
      <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header myModal auctionTableHeader">Place Bid</div>
              <div class="modal-body">
                  <input type="hidden" id="auctionID">
                  <label class = "control-label" for="bidTxt">Enter bid amount:</label>
                  <div class = "controls regControl input-symbol-dollar">
                      <span>$</span>
                      <input type="text" class="form-control" name="bidTxt" id="bidTxt">
                  </div>
              </div>
              <div class="modal-footer">
                  <button id="placeBidBtn" class="btn btn-primary" data-dismiss="modal" onclick="placeBid(auctionID, bidTxt.value)" aria-hidden="true">OK</button>
              </div>
            </form>
          </div>
      </div>
  </div> <!-- bidModal -->
  <table id ="auctionDataTable" class="table table-striped table-bordered dt-responsive nowrap auctionHouseTable">
      <thead>
        <tr>
          <th width="1%"></th>
          <th>Item</th>
          <th>Seller</th>
		      <th>Minimum Bid</th>
          <th>Current Bid</th>
          <th>Time Left</th>
          <th>Winner</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <%
          while(res.next()) {
            int auctionID = res.getInt("AuctionID");
          %>
          <tr>
            <td>
              <button type="button" class="btn btn-default btn-sm">
                <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
              </button>
            </td>
            <td>
              <!-- Display the details of an item when its name is clicked -->
              <a href="javascript:showItemDetails('<%= res.getString("ItemName") %>',
                                                      '<%= res.getString("ItemType")%>',
                                                      '<%= res.getString("Description")%>',
                                                      '<%= res.getString("ItemYear")%>',
                                                      '<%= res.getString("NumCopies") %>' )">
              <%=res.getString("ItemName")%>
            </a>
            </td>
            <td>
              <%=res.getString("SellerUsername")%>
            </td>
            <td>
              US $<%=res.getString("MinimuBid")%>
            </td>
			<td>
              <% String empty = "-";
                if (res.getInt("CurrentBid") == 0) {
                  int temp = 1; %>
                  <%= empty %>
                <% } else { %>
                  US $<%=res.getString("CurrentBid")%>
                <% } %>
            </td>
			<td <% if (res.getString("Expired").equals("Y")) { %> class="expired" <% } else { %> class="active" <% } %> >
              <% long seconds = Long.parseLong(res.getString("SecondsLeft"));
               int day = (int)TimeUnit.SECONDS.toDays(seconds);
               long hours = TimeUnit.SECONDS.toHours(seconds) - (day *24);
               long minute = TimeUnit.SECONDS.toMinutes(seconds) - (TimeUnit.SECONDS.toHours(seconds)* 60);
               long second = TimeUnit.SECONDS.toSeconds(seconds) - (TimeUnit.SECONDS.toMinutes(seconds) *60);
              %>
              <%= day + "d " + hours + "h " + minute + "m" %>
            </td>
            <td>
              <% String winner = "";
                 if (res.getString("Expired").equals("Y")) {
                   cs = conn.prepareCall("call GetAuctionWinner(?)");
                   cs.setInt(1, auctionID);
                   cs.execute();
                   winnerRes = cs.getResultSet();

                   while (winnerRes.next()) {
                       winner = winnerRes.getString("Username");
                   }
                 } %>
              <%=winner%>
            </td>
            <td width = "1%">
               	<% if ( !res.getString("SellerUsername").equals(username) && res.getString("Expired").equals("N") && isCustomer) { %>
					<button id="BidButton" class="btn btn-primary" onclick="auctionAction(this)" aria-hidden="true"
					value="<%=res.getInt("AuctionID")%>">Bid Now</button>
				<%	} %>
            </td>
          </tr>
          <tr>
            <!-- Get the auction bid history -->
            <td colspan="5">
              <div class="bidHistory panel-primary">
                  <div class="panel-heading" style="background-color:#20E85E;">
                    <h3 class="panel-title">Bid History</h3>
                  </div>
                  <table class ="table table-hover bidHistoryTable">
                    <thead>
                      <tr>
                        <th>User</th>
                        <th>Current Bid $</th>
                        <th>Bid Time</th>
                      </tr>
                    </thead>
                    <tbody>
                    <%
                    cs = conn.prepareCall("call GetAuctionBidHistory(?)");
                    cs.setInt(1, auctionID);
                    cs.execute();

                    // Extract the status and the return msg
                    bidHistoryRes = cs.getResultSet();
                    // TODO. Error handling
                    if (cs.getMoreResults()) {
                      bidHistoryRes = cs.getResultSet();
                      SimpleDateFormat dt1 = new SimpleDateFormat("MMMM dd, yyyy hh:mm:ss a");
                      Date date;
                      Timestamp timestamp;
                      while (bidHistoryRes.next()) {
                          timestamp = bidHistoryRes.getTimestamp("BidTime");
                      %>
                      <tr>
                        <td>
                          <%= bidHistoryRes.getString("BuyerUsername") %>
                        </td>
                        <td>
                          <%= bidHistoryRes.getBigDecimal("BidPrice") %>
                        </td>
                        <td>
                          <%
                              if (timestamp != null) {
                                date = new Date(timestamp.getTime());
                          %>
                          <%= 	dt1.format(date) %>
                          <%  } %>
                        </td>
                  </tr>
                       <% } // while (bidHistoryRes.next())
                     } // if (cs.getMoreResults())
                  %>
            </tbody>
          </table>
        </div> <!-- bidHistory -->
            <% } // while(allAuctionsRes.next())
          } catch (Exception e) {
              e.printStackTrace();
            } finally {
              try {
                userTypeRes.close();
                winnerRes.close();
                bidHistoryRes.close();
                res.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
          } %>
        </td>
      </tr>
      </tbody>
      </table>
