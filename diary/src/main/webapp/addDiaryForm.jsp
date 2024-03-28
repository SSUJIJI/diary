<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import="java.net.*"%>
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

	String checkDate = request.getParameter("checkDate");
	if(checkDate == null){
		checkDate = "";
	}
	String ck = request.getParameter("ck");
	if(ck == null){
		ck = "";
	}
	
	String msg = "";
	if(ck.equals("T")){
		msg = "입력이 가능한 날짜입니다.";
	} else if(ck.equals("F")){
		msg = "일기가 이미 존재하는 날짜입니다.";
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addDiaryForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
	<style>
	.na {
		font-family: "Nanum Pen Script", cursive;
		font-weight: 400;
		font-style: normal;
		}
	.c {
		border-radius:6px;
	}
	
	</style>	
	
</head>
<body class = "na container p-5 my-5 border text-white" style = "background-size:100%;background-image:url(/diary/img/sea.jpg)" >
		<table>
		<tr>
			<td>checkDate :<%=checkDate %></td>
		</tr>
		<tr>
			<td>ck :<%=ck %></td>
		</tr>
		</table>
		<h1>일기쓰기</h1>
		<hr>
			<table>
			<form method = "post" action = "/diary/checkDateAction.jsp">
				<tr>
					<td>날짜확인 : <input class="rounded btn btn-outline-light" type = "date" name = "checkDate" value = "<%=checkDate%>">
					<button type = "submit" class="rounded btn btn-outline-light" >날짜가능확인</button></td>
					<div><%=msg%></div>
				</tr>	
			</form>
			</table>
			<table>
			<form method = "post" action = "/diary/addDiaryAction.jsp" >
			<tr>
				<td>날짜 :
				<%
					if(ck.equals("T")){
				%>		
				<input class="rounded btn btn-outline-light" type = "text" name = "diaryDate" readonly = "readonly" value ="<%=checkDate %>">
				<%
					} else{
				%>		
				<input class="rounded btn btn-outline-light" value="" type="text" name="diaryDate" readonly="readonly">
				<%
					}
				%></td>
			</tr>
			<tr>
				<td>기분 :
				<input type = "radio" name = "feeling" value="&#128516;">&#128516;
				<input type = "radio" name = "feeling" value="&#128557;">&#128557;
				<input type = "radio" name = "feeling" value="&#129298;">&#129298;
				<input type = "radio" name = "feeling" value="&#128545;">&#128545;
				<input type = "radio" name = "feeling" value="&#128543;">&#128543;
				</td>
			</tr>
			<tr>
				<td>제목 :
				<input class="rounded btn btn-outline-light" type = "text" name = "title"></td>
			</tr>
			<tr>
				<td>날씨 : <select name = "weather" class="rounded btn btn-outline-light" >
					<option class="text-black" value = "맑음" >맑음 &#9728;</option>
					<option class="text-black" value = "흐림">흐림 &#9925;</option>
					<option class="text-black" value = "비">비 &#9748;</option>
					<option class="text-black" value = "눈">눈 &#10052;</option>
				</select></td>
			</tr>
			<tr>
			<td> <textarea class="rounded btn btn-outline-light"  rows="10" cols="70" name = content></textarea> </td>
			</tr>
			<tr>
				<td><button type = "submit" class="rounded btn btn-outline-light" >일기쓰기</button></td>
			</tr>	
			</form>
			</tr>
	</table>
</body>
</html>