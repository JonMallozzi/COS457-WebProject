<%
    /******************************************************************************
     * Jon Mallozzi                                                               *
     * COS 457                                                                    *
     * Databases                                                                  *
     * WebProject                                                                 *
     * All CSS, Table Formating/Display, JDBC Set Up Was Taken From Checkdb.jsp   *
     * Or The ScripletQuery example                                               *
     * The Rest of the Code Was All Written By Myselft                            *
     *****************************************************************************/

%>

<!doctype html public "-//w3c/dtd HTML 4.0//en">
<html>
<head>
<title>Jon Mallozzi WebProject</title>
<style type="text/css">
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
</style>
</head>

<body bgcolor="#FFFFFF">

<a href="/~mallozzi/webProject/input.html">Return Back To Query Input Page <br/><br/></a>

<%@ page import="java.util.*,java.sql.*,org.postgresql.*,java.text.SimpleDateFormat" %>

<%
    String dbURL = "jdbc:postgresql://moth.cs.usm.maine.edu/senators" +
    		   "?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory";
    String jdbcDriver = "org.postgresql.Driver";
    //---------------------------------------------------------------
    // Make credential modifications here
    //---------------------------------------------------------------
    String username = "mallozzi";
    String passwd = "password123";
%>

<%

    //converts strings to input for error checking
    //and the query except for the date
    String lsnm = request.getParameter("loSname");
    String hsnm = request.getParameter("hiSname");
    String lcnm = request.getParameter("loCname");
    String hcnm = request.getParameter("hiCname");
    String ldate = request.getParameter("loDate");
    String hdate = request.getParameter("hiDate");

    //date storage for comparison before the java.sql.dates are made
    java.util.Date checkLDate = null;
    java.util.Date checkHDate = null;

    /******* INPUT STRING VALIDATION ******/

    //holds all error messages
    ArrayList<String> errorMessages = new ArrayList<String>();

    /******* SENATOR VALIDATION ***********/
    //boolean flag for if a senator input error occurs
    boolean senError = false;

    if(lsnm == null){
        errorMessages.add("<b>Low limit of the senator name range is missing.<b> <br/>");
        senError = true;
    }

    if(hsnm == null){
        errorMessages.add("<b>High limit of the senator name range is missing.<b> <br/>");
        senError = true;
    }else {

        if(!(lsnm.trim().length() > 0)){
            errorMessages.add("<b>Low limit of the senator name range is empty.<b><br/>");
            senError = true;
        }else if(!(lsnm.matches("[a-zA-Z]+"))){
            errorMessages.add("<b>Low limit of the senator name range has non-letter characters.<b> <br/>");
            senError = true;
        }

        if(!(hsnm.trim().length() > 0)){
            errorMessages.add("<b>High limit of the senator name range is empty.<b> <br/>");
            senError = true;
        }else if(!(hsnm.matches("[a-zA-Z]+"))){
            errorMessages.add("<b>High limit of the senator name range has non-letter characters.<b> <br/>");
            senError = true;
        }
    }

    if(!senError){
        if(hsnm.compareTo(lsnm) < 0){
            errorMessages.add("<b>Empty senator name range.<b> <br/>");
            senError = true;
        }
    }

   /******* CORPORATION VALIDATION *******/

    //boolean flag for if a corporation input error occurs
    boolean corpError = false;

    if(lcnm == null){
        errorMessages.add("<b>Low limit of the corporation name range is missing.<b> <br/>");
        corpError = true;
    }

    if(hcnm == null){
        errorMessages.add("<b>High limit of the corporation name range is missing.<b> <br/>");
        corpError = true;
    }else{
        if(!(lcnm.trim().length() > 0) || !(lcnm.matches("[a-zA-Z].*?[a-zA-Z]"))){
            errorMessages.add("<b>Low limit of the corporation name range is wrong format.<b> <br/>");
            corpError = true;
        }

        if(!(hcnm.trim().length() > 0) || !(hcnm.matches("[a-zA-Z].*?[a-zA-Z]"))){
            errorMessages.add("<b>High limit of the corporation name range is wrong format.<b> <br/>");
            corpError = true;
        }
    }

    if(!corpError){
        if(hcnm.compareTo(lcnm) < 0){
            errorMessages.add("<b>Empty corporation name range.<b> <br/>");
            corpError = true;
        }
    }

    /******* DATE VALIDATION *************/

   //boolean flag for if a date error occurs
    boolean dateError = false;

    if(ldate == null){
        errorMessages.add("<b>Low limit of the date range is missing.<b> <br/>");
        dateError = true;
    }

    if(hdate == null){
        errorMessages.add("<b>High limit of the date range is missing.<b> <br/>");
        dateError = true;
    }else{

        if(!(ldate.matches("\\d\\d\\d\\d-\\d?\\d-\\d?\\d"))){
            errorMessages.add("<b>Low limit of the date range is of the wrong format.<b> <br/>");
            dateError = true;
        }else{

            //formats the date for us
            //could be a function but I found getting a function to work jsp kinda tricky
            try {
                SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
                dateFormatter.setLenient(false);
                checkLDate = dateFormatter.parse(ldate);
            } catch (Exception e) {
                errorMessages.add("<b>Low limit of the date range is not a valid date.<b> <br/>");
                dateError = true;
            }
        }

        if(!(hdate.matches("\\d\\d\\d\\d-\\d?\\d-\\d?\\d"))){
            errorMessages.add("<b>High limit of the date range is of the wrong format.<b> <br/>");
            dateError = true;
        }else{
            try {
                SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
                dateFormatter.setLenient(false);
                checkHDate = dateFormatter.parse(hdate);
            } catch (Exception e) {
                errorMessages.add("<b>High limit of the date range is not a valid date.<b> <br/>");
                dateError = true;
            }
        }
    }

    if(!dateError){
        if(checkHDate.compareTo(checkLDate) < 0){
            errorMessages.add("<b>Empty date range.<b> <br/>");
            dateError = true;
        }
    }

   if(senError || corpError || dateError){

       //printing error messages
       out.print("<h2>Error Invalid Input For The Query<h2>");

       for(String message : errorMessages){
           out.print(message);
       }
       return;
   }

    //sets the string to a java.sql.date now they are in valid
    //and can be used in the prepared statement
    java.sql.Date lodate = java.sql.Date.valueOf(request.getParameter("loDate"));
    java.sql.Date hidate = java.sql.Date.valueOf(request.getParameter("hiDate"));

%>

<h2>Query Results From Given Input:</h2>

<%

    Connection conn = null;
    Statement stmt = null;

    try {

        Class.forName(jdbcDriver).newInstance();
        conn = DriverManager.getConnection(dbURL, username, passwd);
        
        //performing the query
        PreparedStatement query = conn.prepareStatement(
"WITH senatorsBound AS ( " +
        "SELECT " +
                  "sname " +
        "FROM senators " +
        "WHERE " +
                "? <= sname " +
            "AND sname <= ? " +
"), " +
"corpsBound AS ( " +
     "SELECT " +
           "cname " +
     "FROM corporations  " +
     "WHERE " +
                "? <= cname " +
          "AND cname <= ? " +
"), " +
"corpsenPair AS( " +
      "SELECT " +
            "sname, " +
            "cname " +
      "FROM senatorsBound " +
      "CROSS JOIN corpsBound " +
"), "  +
"originalContrib AS ( " +
     "SELECT " +
           "sname, " +
           "cname, " +
           "amt " +
     "FROM contributes " +
     "WHERE " +
              "sname IN (SELECT sname FROM senatorsBound) " +
          "AND cname IN (SELECT cname FROM corpsBound) " +
          "AND " +
                "? <= cdate " +
          "AND cdate <= ? " +
") " +
"SELECT " +
      "cname, " +
      "sname, " +
      "COALESCE(COUNT(amt),0) as contribCount, " +
      "COALESCE(SUM(amt),0) AS contribSum " +
"FROM originalContrib " +
"FULL OUTER JOIN corpsenPair USING(sname, cname) " +
"GROUP BY cname, sname " +
"ORDER BY cname, sname"
        );

        //setting all the question marks in the 
        //PreparedStatement to the input variables
        query.setString(1,lsnm);
        query.setString(2,hsnm);
        query.setString(3,lcnm);
        query.setString(4,hcnm);
        query.setDate(5,lodate);
        query.setDate(6,hidate);

        ResultSet rset = query.executeQuery();
        
        ResultSetMetaData querymd = rset.getMetaData();
        int numCols = querymd.getColumnCount();

        //using the metaData and numCols to
        //print the exact table from checkdb to the page
%>

<table class="mytable">
<tr>

<%
        for (int i = 1; i <= numCols; i++) {
%>

<td class="header"><%= querymd.getColumnLabel(i) %></td>

<%
        }
%>

</tr>

<%
        while (rset.next()) {
%>
<tr>
<%
          for (int i = 1; i <= numCols; i++) {
%>
<td class="cdata"><%= rset.getString(i) %></td>
<%
          }
%>

</tr>
<%
          }
	} catch (Exception ex) {
%>
	<h2>Sorry could not get information<br/>
    Your error was: <%= ex %> </h2>
<%
	}
%>
</table>
</body>
</html>
