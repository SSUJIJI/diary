<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import = "java.util.*" %>

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
<title></title>
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

<% 
	if(rs2.next()){
%>			<form>
			<table class= "table table-bordered text-white rounded">
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
			<table>
				<form method = "post" action = "/diary/checkAction.jsp">
					<tr>
						<td>날짜확인 : <input class="rounded btn btn-outline-light" type = "date" name = "checkDate" value = "<%=checkDate%>"></td>	
						<td><button type = "submit" class="rounded btn btn-outline-light" >날짜가능확인</button></td>
						<td><%=msg%></td>
					</tr>
				</form>
			</table>
			<form method="get" action="/diary/lunchAction.jsp">
				<table>
					<tr>
						<td>date
					<%
						if(ck.equals("T")){
					%>
						<input  class="rounded btn btn-outline-light" type = "text" name = "lunchDate" readonly = "readonly" value ="<%=checkDate %>">
					<%		
						} else{
					%>		
						<input class="rounded btn btn-outline-light" value="" type="text" name="lunchDate" readonly="readonly">
					<%
						}
					%>
						
						</td>
					</tr>
					<tr>
						<td>menu
						<input class="rounded btn btn-outline-light" type = "radio" name = "menu" value = 한식>한식
						<input class="rounded btn btn-outline-light" type = "radio" name = "menu" value = 중식>중식
						<input class="rounded btn btn-outline-light" type = "radio" name = "menu" value = 일식>일식
						<input class="rounded btn btn-outline-light" type = "radio" name = "menu" value = 양식>양식
						<input class="rounded btn btn-outline-light" type = "radio" name = "menu" value = 기타>기타
						</td>
					</tr>
				</table>
				<button class="rounded btn btn-outline-light" type = "submit">투표 제출</button>
			</form>
			
	
<%
	}
%>		

		
		


</body>
</html>