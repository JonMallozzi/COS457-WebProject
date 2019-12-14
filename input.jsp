<!DOCTYPE html>
<html>
<head>
<title>JDBC Table JSP</title>
<style type="text/css">
    h2.heading {
        font: bolder 180% georgia, verdana, sans-serif;
        color: #f00;
    }
    table.mytable {
        border: 1px solid #000;
        margin: 0;
        padding: 0;
	width:800px;
    }
    td.header {
        font: bolder 130% georgia, verdana, sans-serif;
        color: white;
        background-color: blue;
        border-bottom: 1px solid #000;
	text-align: center;
    }
    td.cdata {
        font: normal 90% verdana, arial, sans-serif;
        background-color: lightblue;
	padding-left: 10px;
    }
    h2.error {
        font: bolder 120% georgia, verdana, sans-serif;
        color: #15e;
    }
</style>
</head>

<body bgcolor="#FFFFFF">

<h2 class="heading">Using JSP to retrieve database data with JDBC</font></h2>
<%@ page import="java.util.*,java.sql.*,org.postgresql.*" %>

<%
    String dbURL = "jdbc:postgresql://moth.cs.usm.maine.edu/senators" +
    		   "?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory";
    String jdbcDriver = "org.postgresql.Driver";
    String sqlQuery = "select * from senators";
    //---------------------------------------------------------------
    // Make credential modifications here
    //---------------------------------------------------------------
    String username = "mallozzi";
    String passwd = "password123";
%>

<form method="get" action="results.jsp"> 

        Low Bound for Senators:
        <input type="text" name="loSname" size="32"></input><br/>

        High Bound for Senators:
        <input type="text" name="hiSname" size="32"></input><br/>

         Low Bound for Corporation:
         <input type="text" name="loCname" size="32"></input><br/>

         High Bound for Corporation:
         <input type="text" name="hiCname" size="32"></input><br/>

         Low Bound for Date:
         <input type="text" name="loDate" size="32"></input><br/>

         High Bound for Date:
         <input type="text" name="hiDate" size="32"></input><br/>

         <input type="submit" value="Submit Query Parameters" ></input>

</form>

<h2>Results from query:</h2>

<%

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
   
    try {

        Class.forName(jdbcDriver).newInstance();
        conn = DriverManager.getConnection(dbURL, username, passwd);
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sqlQuery);

        ResultSetMetaData rsmd = rs.getMetaData();
        int numCols = rsmd.getColumnCount();
%>

<table class="mytable">
<tr>

<%
        for (int i = 1; i <= numCols; i++) {
%>

<td class="header"><%= rsmd.getColumnLabel(i) %></td>

<%
        }
%>

</tr>

<%
        while (rs.next()) {
%>
<tr>
<%
          for (int i = 1; i <= numCols; i++) {
%>
<td class="cdata"><%= rs.getString(i) %></td>
<%
          }
%>

</tr>
<%
          }
	} catch (Exception ex) {
%>
	<h2>Sorry could not get information</h2>
<%
	}
%>
</table>
<!--- change this too -->
<a href="/~mallozzi">Return to my website</a>
</body>
</html>
