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
    Date issueDate = new Date();

    // Check if parameters are not null or empty
    if (assetid != null && friendid != null && !assetid.isEmpty() && !friendid.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // Establish database connection (replace databaseURL, username, and password with your own)
            String databaseURL = "jdbc:mysql://localhost:3306/assetdata";
            String username = "root";
            String password = "sqlpass@135";
            conn = DriverManager.getConnection(databaseURL, username, password);

            // Update asset status to 'issued' in the assetlist table
            String updateSql = "UPDATE assetlist SET assetstatus = 'issued' WHERE assetid = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, assetid);
            pstmt.executeUpdate();

            // Insert record into assetissuedetail table
            String insertSql = "INSERT INTO assetissuedetail (asset_id, friend_id, date_issue) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, assetid);
            pstmt.setString(2, friendid);
            pstmt.setDate(3, new java.sql.Date(issueDate.getTime()));
            int rowsAffected = pstmt.executeUpdate();

            // Check if the insertion was successful
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
