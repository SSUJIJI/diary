<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>

<%
	String diaryDate = request.getParameter("diaryDate");
	String feeling = request.getParameter("feeling");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	String update = request.getParameter("update");
	String create = request.getParameter("create");
	
	System.out.println(diaryDate);
	System.out.println(feeling);
	System.out.println(title);
	System.out.println(weather);
	System.out.println(content);
	System.out.println(update);
	System.out.println(create);
	
	String sql = "UPDATE diary SET feeling = ? ,title = ?, content=? ,update_date=now() WHERE diary_date=? AND weather = ?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,feeling);
	stmt.setString(2,title);
	stmt.setString(3,content);
	stmt.setString(4,diaryDate);
	stmt.setString(5,weather);
	
	int row = 0;
	System.out.println(stmt);
	
	row = stmt.executeUpdate();
	
	if(row == 1){
		response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
	} else {
		response.sendRedirect("/diary/updateDiaryForm.jsp?diaryDate="+diaryDate);
	}
%>
