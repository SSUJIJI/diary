<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	String lunchDate = request.getParameter("lunchDate");
	String menu = request.getParameter("menu");
	
	System.out.println(lunchDate);
	System.out.println(menu);

	String sql1 = "INSERT INTO lunch (lunch_date,menu,update_date,create_date) VALUES (?,?,NOW(), NOW())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1,lunchDate);
	stmt1.setString(2,menu);
	
	int row = 0;
	
	System.out.println(stmt1);
	row = stmt1.executeUpdate();
	
	if(row == 0){
		response.sendRedirect(
				"/diary/lunchOne.jsp");
	} else{
		response.sendRedirect(
				"/diary/statsLunch.jsp");
	}
%>

