<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.SimpleDateFormat"%>
<%
//로그인(인증) 분기
// diary.login.my_session -> "ON"일때만 "OFF"면 redirect("loginForm.jsp") <-- db설정하는 것
	
	String sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	String mySession = null;
	

	if (rs1.next()) {
		mySession = rs1.getString("mySession");
	}
	if (mySession.equals("OFF")) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg); // <-get 방식
		// db자원반납 (return전에)
		return; //코드 진행을 끝냄 ex)메소드 끝낼 때 return사용
}
%>
<%
	
	String sql2 = "SELECT lunch_date lunchDate, menu, update_date updateDate, create_date createDate FROM lunch WHERE lunch_date = curdate()";
	
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	ResultSet rs2 = null;
	rs2 = stmt2.executeQuery();
	System.out.println(stmt2);
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>

<% 
	if(rs2.next()){
%>			<form>
			<table>
				<tr>
					<td>date</td>
					<td><%=rs2.getString("lunchDate") %></td>
				</tr>
				<tr>
					<td>menu</td>
					<td><%=rs2.getString("menu") %></td>
				</tr>
				<tr>
					<td>update</td>
					<td><%=rs2.getString("updateDate") %></td>
				</tr>
				<tr>
					<td>create</td>
					<td><%=rs2.getString("createDate") %></td>
				</tr>
				
			</table>
			<div>
				<a href = "/diary/deleteLunchAction.jsp?lunchDate=<%=rs2.getString("lunchDate") %>" class = "btn btn-outline-light">지우기</a>
			</div>
			
		</form>
<%		
	}else{
%>		
			<h1>투표하기</h1>
			<form method="get" action="/diary/lunchAction.jsp">
				<table>
					<tr>
						<td>date
						<input type="date" name="lunchDate">
						</td>
					</tr>
					<tr>
						<td>menu
						<input type = "radio" name = "menu" value = 한식>한식
						<input type = "radio" name = "menu" value = 중식>중식
						<input type = "radio" name = "menu" value = 일식>일식
						<input type = "radio" name = "menu" value = 양식>양식
						<input type = "radio" name = "menu" value = 기타>기타
						</td>
					</tr>
				</table>
				<button type = "submit">투표 제출</button>
			</form>
			
	
<%
}
		
%>		

		
		


</body>
</html>