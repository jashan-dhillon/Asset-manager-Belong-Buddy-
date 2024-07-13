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
        // String sql = "SELECT * FROM assetissuedetail where date_receive IS NULL ";

        String sql = "SELECT aid.asset_id, " +
               "       al.assetname AS asset_name, " +
               "       aid.friend_id, " +
               "       fl.fname AS friend_name, " +
               "       fl.fphone AS friend_phone, " +
               "       fl.femail AS friend_email, " +
               "       aid.date_issue, " +
               "       aid.date_receive " +
               "FROM assetissuedetail aid " +
               "JOIN assetlist al ON aid.asset_id = al.assetid " +
               "JOIN friendlist fl ON aid.friend_id = fl.fid " +
               "WHERE aid.date_receive IS NULL;";


        
        // Prepare the statement
        pstmt = conn.prepareStatement(sql);
        // Execute the query
        rs = pstmt.executeQuery();
        // Iterate through the result set and add data to JSON array
        while (rs.next()) {
            
            JSONObject jsonObject = new JSONObject();
            
            // Add data to the JSON object
            //jsonObject.put("asset_id", rs.getInt("asset_id"));
            jsonObject.put("asset_name", rs.getString("asset_name"));
           // jsonObject.put("friend_id", rs.getInt("friend_id"));
            jsonObject.put("friend_name", rs.getString("friend_name"));
            jsonObject.put("friend_phone", rs.getString("friend_phone"));
            jsonObject.put("friend_email", rs.getString("friend_email"));
            jsonObject.put("date_issue", rs.getString("date_issue"));
            //jsonObject.put("date_receive", rs.getString("date_receive"));
            
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
