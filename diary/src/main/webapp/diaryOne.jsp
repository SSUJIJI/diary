<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	//로그인(인증) 분기
	// diary.login.my_session -> "ON"일때만 "OFF"면 redirect("loginForm.jsp") <-- db설정하는 것
	
	String sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	String mySession = null;
	if(rs1.next()){
		mySession = rs1.getString("mySession");
	}
	if(mySession.equals("OFF")) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.","utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); // <-get 방식
		// db자원반납 (return전에)
		rs1.close();
		stmt1.close();
		conn.close();
		return; //코드 진행을 끝냄 ex)메소드 끝낼 때 return사용
	} 
%>
<%
	
	String diaryDate = request.getParameter("diaryDate");

	System.out.println(diaryDate);
	
	String sql2 = "SELECT diary_date diaryDate, feeling, title, weather, content, update_date updateDate, create_date createDate FROM diary WHERE diary_date=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,diaryDate);
	rs2 = stmt2.executeQuery();
	
	System.out.println(stmt2);
	

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>diaryOne</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
	<style>
		a:visited{color:white; text-decoration:none;}
		a:hover{color:white; text-decoration:none;}
		a.groove{border-style: groove;}
		a.active{color:white; text-decoration:none;}
	   	.na {
			font-family: "Nanum Pen Script", cursive;
			font-weight: 400;
			font-style: normal;
		}
		.c {
			margin-top: 150px;
		}
	
	</style>
</head>
<body class = "na c container p-5 my-5 border text-white text-center rounded" style = "background-size:100%;background-image:url(/diary/img/sea.jpg)">
	<div>
	<h1>상세내용</h1>
	<%
		if(rs2.next()){
	%>
			<table class= "table table-bordered text-white rounded">
				<tr> 
					<td>date </td>
					<td><%=rs2.getString("diaryDate")%></td>
				</tr>
				<tr>
					<td>feeling</td>
					<td><%=rs2.getString("feeling") %></td>
				</tr>
				<tr>
					<td>title </td>
					<td><%=rs2.getString("title") %></td>
				</tr>
				<tr>
					<td>weather </td>
					<td><%=rs2.getString("weather") %></td>
				</tr>
				<tr>
					<td>content </td>
					<td><%=rs2.getString("content") %></td>
				</tr>
				<tr>
					<td>update </td>
					<td><%=rs2.getString("updateDate") %></td>
				</tr>
				<tr>
					<td>create </td>
					<td><%=rs2.getString("createDate") %></td>
				</tr>
				</table>
	<%
			}
	%>
	
	<div >
		<a href = "/diary/deleteDiaryAction.jsp?diaryDate=<%=rs2.getString("diaryDate") %>" class = "btn btn-outline-light">지우기</a>
		<a href = "/diary/updateDiaryForm.jsp?diaryDate=<%=rs2.getString("diaryDate") %>" class = "btn btn-outline-light">수정하기</a>
	</div>
		</div>
		
	
</body>
</html>