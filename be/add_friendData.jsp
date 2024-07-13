<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Save Data</title>
</head>
<body>

<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/assetdata";
    String username = "root";
    String password = "sqlpass@135";
    
    // Retrieve data from request parameters
    String name = request.getParameter("friendName");
    String email = request.getParameter("friendEmail");
    String phone = request.getParameter("friendPhone");
    String address = request.getParameter("friendAddress");
    String details = request.getParameter("friendDetails");
    
    // JDBC variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish the database connection
        conn = DriverManager.getConnection(url, username, password);
        
        // SQL query to insert a record
        String sql = "INSERT INTO friendlist (fname, femail, fphone, faddress, fdetails) VALUES (?, ?, ?, ?, ?)";
        
        // Prepare the statement
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, email);
        pstmt.setString(3, phone);
        pstmt.setString(4, address);
        pstmt.setString(5, details);
        
        // Execute the query
        int rowsAffected = pstmt.executeUpdate();

        
        
        // Send a response indicating success
        if (rowsAffected > 0) {
%>           
            <div class="success-message">
                Data saved successfully!
            </div>
            <button onclick="window.location.href='../fe/main.html'">Home</button>
<%
        } else {
            out.println("<h2>Error: Data not saved</h2>");
        }
    } catch (Exception e) {
        // Send an error response if an exception occurs
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        // Close JDBC objects
        if (pstmt != null) {
            pstmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>

</body>
</html>
