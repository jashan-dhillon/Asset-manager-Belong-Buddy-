<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="java.sql.*, java.util.Calendar" %>
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

    // Get the current date
    Calendar calendar = Calendar.getInstance();
    java.sql.Date currentDate = new java.sql.Date(calendar.getTimeInMillis());

    // JSON array to store table data
    JSONArray jsonArray = new JSONArray();

    try {
        // Establish the database connection
        conn = DriverManager.getConnection(url, username, password);

        // SQL query to select records where date_issue is more than 10 days from the current date
       // String sql = "SELECT * FROM assetissuedetail WHERE DATEDIFF(?, date_issue) > 10";

        // Prepare the statement
       // pstmt = conn.prepareStatement(sql);
      //  pstmt.setDate(1, currentDate);

        String sql = "SELECT fl.fname, fl.femail, al.assetname " +
            "FROM assetissuedetail aid " +
            "JOIN friendlist fl ON aid.friend_id = fl.fid " +
            "JOIN assetlist al ON aid.asset_id = al.assetid " +
            "WHERE DATEDIFF(CURDATE(), aid.date_issue) > 10";

        // Prepare the statement
        pstmt = conn.prepareStatement(sql);

        // Execute the query
        rs = pstmt.executeQuery();

        // Iterate through the result set
        while (rs.next()) {
            JSONObject obj = new JSONObject();
            obj.put("fname", rs.getString("fname"));
            obj.put("femail", rs.getString("femail"));
            obj.put("assetname", rs.getString("assetname"));

            // Add more attributes if needed
            jsonArray.add(obj);
        }
    } catch (SQLException e) {
        // Handle exceptions
        e.printStackTrace();
        // Send error response
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.println("{ \"error\": \"" + e.getMessage() + "\" }");
    } finally {
        // Close JDBC objects
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.println("{ \"error\": \"" + ex.getMessage() + "\" }");
        }
    }

    // Send JSON response
    out.println(jsonArray.toJSONString());
%>


