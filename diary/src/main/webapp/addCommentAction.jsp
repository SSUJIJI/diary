<%@page import="java.lang.ProcessBuilder.Redirect"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<%

	String diaryDate = request.getParameter("diaryDate");
	String memo = request.getParameter("memo");	
	System.out.println(diaryDate);
	System.out.println(memo);

	String sql1 = "INSERT INTO COMMENT(diary_date,memo,update_date,create_date) VALUES(?, ?, NOW(), NOW())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1,diaryDate);
	stmt1.setString(2,memo);
	int row = 0;
	row = stmt1.executeUpdate();
	System.out.println(stmt1);
	
	if(row == 1){
		System.out.println("입력성공");
	}	else{
		System.out.println("입력실패");
	}
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
%>	