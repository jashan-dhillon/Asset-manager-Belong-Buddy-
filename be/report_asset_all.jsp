<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="application/json" %>
<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/assetdata";
    String username = "root";
    String password = "sqlpass@135";

    // JDBC variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // JSON array to store table data
    JSONArray jsonArray = new JSONArray();

    try {
        // Establish the database connection
        conn = DriverManager.getConnection(url, username, password);
        
        // SQL query to retrieve table data with known fields
        String sql = "SELECT assetid, assetname, assettype, category, assetprice, dateofpurchase, details, assetstatus FROM assetlist";
        
        // Prepare the statement
        pstmt = conn.prepareStatement(sql);
        // Execute the query
        rs = pstmt.executeQuery();
        // Iterate through the result set and add data to JSON array
        while (rs.next()) {
            JSONObject jsonObject = new JSONObject();
            // Iterate through all columns and add them to the JSON object
            jsonObject.put("assetid", rs.getInt("assetid"));
            jsonObject.put("assetname", rs.getString("assetname"));
            jsonObject.put("assettype", rs.getString("assettype"));
            jsonObject.put("category", rs.getString("category"));
            jsonObject.put("assetprice", rs.getDouble("assetprice"));
            // Format the date of purchase as a string in "yyyy-MM-dd" format
            //Date dateOfPurchase = rs.getDate("dateofpurchase");
            //String formattedDateOfPurchase = "\"" + new SimpleDateFormat("yyyy-MM-dd").format(dateOfPurchase) + "\"";
            // Add the formatted date to the JSON object
            //jsonObject.put("dateofpurchase", formattedDateOfPurchase);
            jsonObject.put("details", rs.getString("details"));
            jsonObject.put("assetstatus", rs.getString("assetstatus"));
            jsonArray.add(jsonObject);
        }
        
        // Send JSON response
        out.println(jsonArray.toJSONString());

    } catch (Exception e) {
        // Handle exceptions
        e.printStackTrace();
        // Send error response
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.println("{ \"error\": \"" + e.getMessage() + "\" }");
    } finally {
        // Close JDBC objects
        if (rs != null) {
            rs.close();
        }
        if (pstmt != null) {
            pstmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
