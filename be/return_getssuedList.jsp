<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, org.json.simple.*" %>
<%
    JSONArray assetList = new JSONArray();
    try {
        // Establish database connection
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/assetdata", "root", "sqlpass@135");
        Statement stmt = con.createStatement();
        
        // Fetch data from assetlist table
        ResultSet rs = stmt.executeQuery("SELECT assetname,assetid FROM assetlist  where assetstatus ='issued' ");
        while (rs.next()) {
            JSONObject asset = new JSONObject();
            asset.put("assetname", rs.getString("assetname"));
            asset.put("assetid", rs.getString("assetid"));
            assetList.add(asset);
        }
        
        // Close connections
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.print(assetList);
%>
