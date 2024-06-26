<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.*"%>
<%
	/*session API 사용*/
	// 로그인 성공시 세션에 loginMember라는 변수를 만들고 값으로 로그인 아이디를 저장 
	String loginMember = (String)(session.getAttribute("loginMember"));
	// session.getAttribute()는 찾는 변수가 없으면 null값을 반환한다. why? 로그인을 한 적이 없으니까.
	// loginMember가 null이면 로그아웃상태, 아니면 로그인 상태 
	System.out.println(loginMember + "<-loginMember");
	
	// loginForm페이지는 로그아웃상태에서만 출력된다.
	//if문으로 loginMember가 null일 때, 아닐 때 구분
	
	
	
	if(loginMember == null) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.","utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg); // <-get 방식
		return;
	}
		
%>
<%

	
	String diaryDate = request.getParameter("diaryDate");
	
	System.out.println(diaryDate + "<-diaryDate");	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql2 = "SELECT title, weather, content, update_date updateDate, create_date createDate from diary WHERE diary_Date = ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,diaryDate);
	
	rs2 = stmt2.executeQuery();
	
	
	System.out.println(stmt2);
	
	





		if(rs2.next()){
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
				<form method = "post" action = "/diary/updateDiaryAction.jsp">
					<table class= "table table-bordered text-white rounded">
						<tr> 
							<td>date : </td>
							<td><input type = "text" name = "diaryDate" readonly=readonly value = <%=diaryDate %> class="rounded btn btn-outline-light"></td>
						</tr>
						<tr>
							<td>feeling : </td>
							<td><input type = "radio" name = "feeling" value="&#128516;" class="rounded btn btn-outline-light">&#128516;
							<input type = "radio" name = "feeling" value="&#128557;" class="rounded btn btn-outline-light">&#128557;
							<input type = "radio" name = "feeling" value="&#129298;" class="rounded btn btn-outline-light">&#129298;
							<input type = "radio" name = "feeling" value="&#128545;" class="rounded btn btn-outline-light">&#128545;
							<input type = "radio" name = "feeling" value="&#128543;" class="rounded btn btn-outline-light">&#128543;</td>
						</tr>
						<tr>
							<td>title : </td>
							<td><input type = "text" name = "title" class="rounded btn btn-outline-light"></td>
						</tr>
						<tr>
							<td>weather : </td>
							<td><input type = "text" name = "weather" readonly = readonly value = <%=rs2.getString("weather") %> readonly = readonly class="rounded btn btn-outline-light"></td>
						</tr>
						<tr>
							<td>content : </td>
							<td><textarea rows="5" cols="50" name = content class="rounded btn btn-outline-light"></textarea> </td>
						</tr>
						<tr>
							<td>create : </td>
							<td><input type = "text" name = "create" value = <%=rs2.getString("createDate") %> readonly = readonly class="rounded btn btn-outline-light"></td>
						</tr>
					</table>
					<div>
						<button type = "submit" class="rounded btn btn-outline-light">수정하기</button>
					</div>
				</form>
	<%
			}
	%>
	
</body>
</html>