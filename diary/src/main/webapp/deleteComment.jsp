<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>

<%
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	System.out.println(commentNo + "<-commentNo");
	String diaryDate = request.getParameter("diaryDate");
	System.out.println(diaryDate+"dddddd");
	
	
	String sql = "DELETE FROM comment WHERE comment_no = ?";
	PreparedStatement stmt = null;
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	int row = 0;
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1,commentNo);
	System.out.println(stmt);
	row = stmt.executeUpdate();
	
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
	
		
	
%>