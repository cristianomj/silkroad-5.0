/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.28
 * Generated at: 2015-12-03 23:08:42 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;

public final class BestSellerView_005fItem_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("java.sql");
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = null;
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

final java.lang.String _jspx_method = request.getMethod();
if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method) && !javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET POST or HEAD");
return;
}

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\r');
      out.write('\n');

String username = "";
if (session.getAttribute("login") != null) {
 username = session.getAttribute("login").toString();
}
else {
 out.println("Invalid session! You must log back into the system.");
 return;
}

String outputMsg = "TODO";

ResultSet itemListRes = null;

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



 
      out.write("\r\n");
      out.write(" <html lang=\"en\">\r\n");
      out.write("  <head>\r\n");
      out.write("   <meta charset=\"utf-8\">\r\n");
      out.write("    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\r\n");
      out.write("     <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\r\n");
      out.write("      <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->\r\n");
      out.write("      <title>Silk Road 5.0</title>\r\n");
      out.write("      <!-- Bootstrap -->\r\n");
      out.write("      <link href=\"css/bootstrap.min.css\" rel=\"stylesheet\">\r\n");
      out.write("       ");
      out.write("\r\n");
      out.write("       <link href=\"css/responsive.bootstrap.min.css\" rel=\"stylesheet\" type=\"text/css\">\r\n");
      out.write("        <link href=\"https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.5/css/bootstrap-dialog.min.css\" rel=\"stylesheet\" type=\"text/css\" />\r\n");
      out.write("        <!-- Our own custom css -->\r\n");
      out.write("        <link href=\"css/stylesheet.css\" rel=\"stylesheet\" type=\"text/css\">\r\n");
      out.write("         <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->\r\n");
      out.write("         <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->\r\n");
      out.write("         <!--[if lt IE 9]>\r\n");
      out.write("         <script src=\"https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js\"></script>\r\n");
      out.write("         <script src=\"https://oss.maxcdn.com/respond/1.4.2/respond.min.js\"></script>\r\n");
      out.write("         <![endif]-->\r\n");
      out.write("         <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->\r\n");
      out.write("         <script src=\"js/jquery-1.11.3.min.js\"></script>\r\n");
      out.write("         <script src=\"js/jquery.validate.js\"></script>\r\n");
      out.write("         ");
      out.write("\r\n");
      out.write("         <!-- Include all compiled plugins (below), or include individual files as needed -->\r\n");
      out.write("         <script src=\"js/bootstrap.min.js\"></script>\r\n");
      out.write("         <script src=\"https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.5/js/bootstrap-dialog.min.js\"></script>\r\n");
      out.write("         <script src=\"js/pattern.js\"></script>\r\n");
      out.write("         <script src=\"js/script.js\"></script>\r\n");
      out.write("         <script src=\"js/editCustomer.js\"></script>\r\n");
      out.write("        </head>\r\n");
      out.write("        <nav class=\"navbar\">\r\n");
      out.write("         <div class=\"container-fluid\">\r\n");
      out.write("          <!-- Brand and toggle get grouped for better mobile display -->\r\n");
      out.write("          <div class=\"navbar-header\">\r\n");
      out.write("           <button type=\"button\" class=\"navbar-toggle collapsed\" data-toggle=\"collapse\" data-target=\"#bs-example-navbar-collapse-1\" aria-expanded=\"false\">\r\n");
      out.write("            <span class=\"sr-only\">Toggle navigation</span>\r\n");
      out.write("            <span class=\"icon-bar\"></span>\r\n");
      out.write("            <span class=\"icon-bar\"></span>\r\n");
      out.write("            <span class=\"icon-bar\"></span>\r\n");
      out.write("           </button>\r\n");
      out.write("          </div>\r\n");
      out.write("          <!-- navbar-header -->\r\n");
      out.write("          <!-- Collect the nav links, forms, and other content for toggling -->\r\n");
      out.write("          <div class=\"myNavbar\">\r\n");
      out.write("           <ul class=\"nav\">\r\n");
      out.write("            <li class=\"floatLeft\"><a href=\"ManagerInformation.jsp\">Home</a></li>\r\n");
      out.write("            <li class=\"dropdown navbar-right\" style=\"padding-left:125px;\">\r\n");
      out.write("             <a data-target=\"#collapseHelp\" data-toggle=\"collapse\">Help<span class=\"caret\"></span></a>\r\n");
      out.write("             <ul>\r\n");
      out.write("              <div id=\"collapseHelp\" class=\"dropdown-menu\">\r\n");
      out.write("               <li><a href=\"javascript:showEmployeeScreenHelp()\">Screens</a></li>\r\n");
      out.write("               <br>\r\n");
      out.write("                <li><a href=\"javascript:showAuctionHelp()\">Auctions</a></li>\r\n");
      out.write("                <br>\r\n");
      out.write("                </div>\r\n");
      out.write("               </ul>\r\n");
      out.write("              </li>\r\n");
      out.write("              <li class=\"dropdown navbar-right\" style=\"padding-left:200px;\">\r\n");
      out.write("               <a data-target=\"#collapseMenu\" data-toggle=\"collapse\" >Menu<span class=\"caret\"></span></a>\r\n");
      out.write("               <ul>\r\n");
      out.write("                <div id=\"collapseMenu\" class=\"dropdown-menu\">\r\n");
      out.write("                  <li><a href=\"backupDatabase.jsp\">Backup Database</a></li><br>\r\n");
      out.write("                  </div>\r\n");
      out.write("                 </ul>\r\n");
      out.write("                </li>\r\n");
      out.write("               </ul>\r\n");
      out.write("               <!-- .nav -->\r\n");
      out.write("              </div>\r\n");
      out.write("              <!-- .myNavbar -->\r\n");
      out.write("             </div>\r\n");
      out.write("             <!-- .container-fluid -->\r\n");
      out.write("            </nav>\r\n");
      out.write("            <body class=\"auctionHouseBody\">\r\n");
      out.write("             ");
 cs = conn.prepareCall("call GetBestSellingItems()");
            		cs.execute();
            		itemListRes = cs.getResultSet();
            	
      out.write("\r\n");
      out.write("             <div id=\"container\">\r\n");
      out.write("             <h4 class=\"auctionTableHeader\">Best Selling Items</h4>\r\n");
      out.write("             <table id =\"itemSuggestionsTable\" class=\"table table-striped table-bordered dt-responsive nowrap auctionHouseTable\">\r\n");
      out.write("      \t\t\t\t\t\t\t\t<thead>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t<tr>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t<th>Name</th>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t<th>Copies Sold</th>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t<th>Item Type</th>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t<th>Description</th>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t<th>Year</th>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t</tr>\r\n");
      out.write("      \t\t\t\t\t\t\t\t</thead>\r\n");
      out.write("      \t\t\t\t\t\t\t\t<tbody>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t");
 while(itemListRes.next()) { 
      out.write("\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t<tr>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t<td>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t\t");
      out.print( itemListRes.getString("Name"));
      out.write("\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t<td>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t\t");
      out.print( itemListRes.getString("TotalSold") );
      out.write("\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("                <td>\r\n");
      out.write("                 ");
      out.print( itemListRes.getString("Type"));
      out.write("\r\n");
      out.write("                </td>\r\n");
      out.write("                <td>\r\n");
      out.write("                 ");
 String description = itemListRes.getString("Description") == null ? "No description" : itemListRes.getString("Description"); 
      out.write("\r\n");
      out.write("                 ");
      out.print( description );
      out.write("\r\n");
      out.write("                </td>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t<td>\r\n");
      out.write("                 ");
 String year = itemListRes.getString("Year").split("-")[0]; 
      out.write("\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t\t");
      out.print( year );
      out.write("\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t\t</td>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t</tr>\r\n");
      out.write("      \t\t\t\t\t\t\t\t\t");
 } 
      out.write("\r\n");
      out.write("      \t\t\t\t\t\t\t\t</tbody>\r\n");
      out.write("      \t\t\t\t\t\t\t</table>\r\n");
      out.write("            </div>\r\n");
      out.write("            </body>\r\n");
      out.write("           </html>\r\n");
      out.write("\r\n");
      out.write("           ");

          } catch(Exception e) {
           e.printStackTrace();
          }
          finally {
           try {
            conn.close();
           } catch(Exception ee) {};
          }
          
      out.write('\r');
      out.write('\n');
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
