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
	int auctionID = Integer.parseInt(request.getParameter("auction"));
	double bidPrice = Double.parseDouble(request.getParameter("bid"));

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

      stmt = conn.createStatement();
      sql = "select ItemID from Auction where AuctionID = " + auctionID;

      ResultSet itemRes = stmt.executeQuery(sql);
      int itemID = -1;
      while(itemRes.next()) {
          itemID = Integer.parseInt(itemRes.getString("ItemID"));
      }
      itemRes.close();

			cs = conn.prepareCall("call PlaceBid(?,?, ?, ?)");
			cs.setInt(1, auctionID);
			cs.setDouble(2, bidPrice);
      cs.setInt(3, itemID);
      cs.setString(4, username);
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
%>
