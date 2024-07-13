<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, org.json.simple.*" %>
<%
    JSONArray friendListArr = new JSONArray();
    try {
        // Establish database connection
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/assetdata", "root", "sqlpass@135");
        Statement stmt = con.createStatement();
        
        // Fetch data from assetlist table
        ResultSet rs = stmt.executeQuery("SELECT fname, fid FROM friendlist");
        while (rs.next()) {
            JSONObject friendname = new JSONObject();
            friendname.put("fname", rs.getString("fname"));
            friendname.put("fid", rs.getString("fid"));

            friendListArr.add(friendname);
        }
        
        // Close connections
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.print(friendListArr);
%>
