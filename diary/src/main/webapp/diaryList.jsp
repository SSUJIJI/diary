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
	//출력 리스트 모듈
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10;
	/*
	if(request.getParameter("rowPerPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}*/
	
	int startRow = (currentPage-1)*rowPerPage;// 1-0,2-10,3-20,4-30,...
	
	String searchWord = "";
	if(request.getParameter("searchWord")!=null){
		searchWord = request.getParameter("searchWord");
	}
	
	String sql2 = "select diary_date diaryDate, title from diary where title like ? order by diary_date desc limit ?,?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,"%"+searchWord+"%");
	stmt2.setInt(2,startRow);
	stmt2.setInt(3,rowPerPage);
	rs2 = stmt2.executeQuery();
	
	
	//lastPage 모듈
	String sql3 = "select count(*) cnt from diary where title like ?";
	PreparedStatement stmt3 = null;
	stmt3 = conn.prepareStatement(sql3);
	ResultSet rs3 = null;
	stmt3.setString(1,"%"+searchWord+"%");
	rs3 = stmt3.executeQuery();
	int totalRow = 0;
	if(rs3.next()){
		totalRow = rs3.getInt("cnt");
	}
	int lastPage = totalRow/rowPerPage;
	if(totalRow/rowPerPage != 0){
		lastPage = lastPage+1;
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
	<h1>일기 목록</h1>
			<div>
				<a href = "/diary/addDiaryForm.jsp" >일기쓰기</a>
				<a href="/diary/diary.jsp" class = "text-white">다이어리 모양으로 보기</a>
				<a href="/diary/diaryList.jsp" class = "text-white">게시판 모양으로 보기</a>
			</div>
		<table class= "table table-bordered text-white rounded">
			<tr>
				<th>날짜</th>
				<th>제목</th>
			</tr>
			<%
				while(rs2.next()){
			%>
					<tr>
						<td><a href="/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>"><%=rs2.getString("diaryDate")%></a></td>
						<td><%=rs2.getString("title") %></td>
					</tr>		
			<%		
				}
			%>
		</table>
		
		<div>
			<a href = "/diary/diaryList.jsp?<%=currentPage-1 %>" class = "text-white">이전</a>
			<a href = "/diary/diaryList.jsp?<%=currentPage+1 %>" class = "text-white">다음</a>
		</div>
		<div>
			<%=currentPage %>/<%=lastPage %>
		</div>
		<form method = "get" action= "/diary/diaryList.jsp">
			<div>
				제목검색 :
				<input type = "text" name = "searchWord" class="rounded btn btn-outline-light" >
				<button type = "submit" class="rounded btn btn-outline-light" >검색</button>
			</div>
		</form>
</body>
</html>