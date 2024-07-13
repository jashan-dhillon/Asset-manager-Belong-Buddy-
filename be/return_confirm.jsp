<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,java.io.*, java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Issue Asset</title>
</head>
<body>
<%
    // Retrieve parameters from the request
    String assetid = request.getParameter("assetid");
    String friendid = request.getParameter("friendid");
    Date returnDate = new Date();

    // Check if parameters are not null or empty
    if (assetid != null && friendid != null && !assetid.isEmpty() && !friendid.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // Establish database connection 
            String databaseURL = "jdbc:mysql://localhost:3306/assetdata";
            String username = "root";
            String password = "sqlpass@135";
            conn = DriverManager.getConnection(databaseURL, username, password);

            // Update asset status to 'available' in the assetlist table
            String updateSql = "UPDATE assetlist SET assetstatus = 'available' WHERE assetid = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, assetid);
            int rowsAffected = pstmt.executeUpdate();

            // Update record in assetissuedetail table
            String updateSql2 = "UPDATE assetissuedetail SET date_receive = ? WHERE asset_id = ? and friend_id = ?";
            pstmt = conn.prepareStatement(updateSql2);
            pstmt.setDate(1, new java.sql.Date(returnDate.getTime()));
            pstmt.setString(2, assetid);
            pstmt.setString(3, friendid);
            rowsAffected = pstmt.executeUpdate(); // Retrieve the number of rows affected
  
            // Check if the update was successful
            if (rowsAffected > 0) {
                out.println("<h1>Asset Issued Successfully!</h1>");
            } else {
                out.println("<h1>Error: Failed to Issue Asset.</h1>");
            }
        } catch (SQLException ex) {
            out.println("<h1>Error: " + ex.getMessage() + "</h1>");
        } finally {
            // Close the database connections
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                out.println("<h1>Error: " + ex.getMessage() + "</h1>");
            }
        }
    } else {
        out.println("<h1>Error: Asset or Friend name is empty.</h1>");
    }
%>

</body>
</html>
