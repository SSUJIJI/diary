<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
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

	System.out.println(diaryDate);
	
	String sql2 = "SELECT diary_date diaryDate, feeling, title, weather, content, update_date updateDate, create_date createDate FROM diary WHERE diary_date=?";
	PreparedStatement stmt2 = null;
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
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
	<div>
			<a href="/diary/diary.jsp" class = "text-white">다이어리로 돌아가기</a>
	</div>
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
	<hr>
	<div >
		<a href = "/diary/deleteDiaryAction.jsp?diaryDate=<%=rs2.getString("diaryDate") %>" class = "btn btn-outline-light">지우기</a>
		<a href = "/diary/updateDiaryForm.jsp?diaryDate=<%=rs2.getString("diaryDate") %>" class = "btn btn-outline-light">수정하기</a>
	</div>
		</div>
	<hr>
		<!-- 댓글 리스트 -->
		<%	
			
			String sql1 = "select comment_no commentNo, memo, create_date createDate from comment where diary_date = ?";
			PreparedStatement stmt1 = null;
			ResultSet rs1 = null;
			stmt1 = conn.prepareStatement(sql1);
			stmt1.setString(1,diaryDate);
			rs1 = stmt1.executeQuery();
			
			System.out.println(stmt1);
		%>
		
			<table border = "1" style = " margin-left:400px;">
			<%
				while(rs1.next()){
			%>
					<tr >
						<td ><%=rs1.getString("memo") %></td>
						<td><%=rs1.getString("createDate") %>&nbsp;</td>
						<td><a href = "/diary/deleteComment.jsp?commentNo=<%=rs1.getInt("commentNo")%>&diaryDate=<%=diaryDate%>" class = "text-white">삭제</a></td>
					</tr>	
			<%
				}
			%>
			</table>
		
		<!-- 댓글 추가 폼 -->
	<br>
	<div >
		<form method="post" action = "/diary/addCommentAction.jsp">
			<input type = "hidden" name = diaryDate value = "<%=diaryDate %> " >
			<textarea rows="2" cols="50" name = "memo" class = "btn btn-outline-light" ></textarea>
			<button type = "submit" class = "btn btn-outline-light">댓글입력</button>			
		</form>
	</div>
	
</body>
</html>