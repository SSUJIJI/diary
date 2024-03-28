<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%

	//로그인(인증) 분기
	// diary.login.my_session -> "ON"일때만 redirect("diary.jsp") <-- db설정하는 것
	
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
	if(mySession.equals("ON")) { //로그인이 됐을 때
		response.sendRedirect("/diary/diary.jsp"); // <-get 방식
		// db자원반납 (return전에)
		rs1.close();
		stmt1.close();
		conn.close();
		return; //코드 진행을 끝냄 ex)메소드 끝낼 때 return사용
	}
	
	rs1.close();
	stmt1.close();
	conn.close();
	
	//1. 요청값 분석
	String errMsg = request.getParameter("errMsg");
	
%>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
	<style>
		.ma{
			margin-top: 300px;	
			margin-left: 500px;
			marign-right:800px;
			
		}
		.max{
			margin-bottom:100px;
			margin-left:500px;
		}
		.na {
			font-family: "Nanum Pen Script", cursive;
			font-weight: 400;
			font-style: normal;
		}
	</style>
</head>
<body class = "na container" style = "background-size:100%;background-image:url(/diary/img/sea.jpg) ">
	<div class= "ma text-white">
		<%
			if(errMsg != null){
		%>	
				<%=errMsg %>
		<%
		}
		%>
	</div>
	<div class = "max container">
	<h1 class = "text-white">로그인</h1>
	<form method = "post" action ="/diary/loginAction.jsp" >
		<table>
			<tr>
			<td class = "text-white">memberId: </td>
			<td><input type = "text" name = "memberId" class="rounded btn btn-outline-light text-white"></td>
			</tr>
			<tr>
			<td class = "text-white">memberPw:</td>
			<td><input type = "password" name = "memberPw" class="rounded btn btn-outline-light"></td>
			</tr>
			<tr>
			<td class = "text-white"><button type = "submit" class="btn btn-outline-light" >로그인</button></td>
			</tr>
		</table>
	</form>
	</div>
</body>
</html>