<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Save Data</title>
    <style>
        .success-message {
            color: green;
            font-weight: bold;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<%
    // Load the MySQL JDBC driver dynamically
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (ClassNotFoundException e) {
        out.println("Error: MySQL JDBC driver not found");
        return;
    }

    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/assetdata";
    String username = "root";
    String password = "sqlpass@135";
    
    // Retrieve data from request parameters
    String name = request.getParameter("assetName");
    String assetType = request.getParameter("assetType");
    String category = request.getParameter("category");
    double assetPrice = Double.parseDouble(request.getParameter("assetPrice"));
    Date purchaseDate = Date.valueOf(request.getParameter("purchaseDate"));
    String details = request.getParameter("details");
    
    // JDBC variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
// Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish the database connection
        conn = DriverManager.getConnection(url, username, password);
        
        // SQL query to insert a record
        String sql = "INSERT INTO assetlist (assetName, assetType, category, assetPrice, dateofpurchase, details, assetstatus) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        // Prepare the statement
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, assetType);
        pstmt.setString(3, category);
        pstmt.setDouble(4, assetPrice);
        pstmt.setDate(5, purchaseDate);
        pstmt.setString(6, details);
        pstmt.setString(7, "available");
        
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
