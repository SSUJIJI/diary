<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>

<% 
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	String feeling = request.getParameter("feeling");
	
	
	System.out.println(diaryDate);
	System.out.println(title);
	System.out.println(weather);
	System.out.println(content);
	
	String sql = "INSERT INTO diary(diary_date, feeling, title, weather, content, update_date, create_date)VALUES(?, ?, ?, ?, ?,NOW(),NOW())";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,diaryDate);
	stmt.setString(2,feeling);
	stmt.setString(3,title);
	stmt.setString(4,weather);
	stmt.setString(5,content);
	
	System.out.println(stmt);

	int row = stmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("입력성공");
		response.sendRedirect("/diary/diary.jsp");
	} else {
		System.out.println("입력실패");
		response.sendRedirect("/diary/addDiaryForm.jsp");
	}
	

%>