<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>

<%
	String diaryDate = request.getParameter("diaryDate");	

	System.out.println(diaryDate);
	
	String sql = "DELETE FROM diary WHERE diary_date = ?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,diaryDate);
	int row = 0;
	
	row = stmt.executeUpdate();
	
	if(row == 0){ // 삭제실패 -> 비밀번호
		response.sendRedirect(
				"/diary/diaryOne.jsp?diaryDate="+diaryDate);
	} else {
		response.sendRedirect("/diary/diary.jsp");	
	}
	
%>