<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
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
	//if문에 안 걸릴 때 
	
	
	//달력 만들기
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	
	Calendar target = Calendar.getInstance();
	
	if(targetYear != null && targetMonth !=null){
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth));
 	}
	
	// 시작공백의 개수 -> 1일의 요일이 필요 -> 요일에 해당된 숫자를 구할 수 잇음 -> target날짜를 1일로 변경
	target.set(Calendar.DATE,1);
	
	// 달력 타이틀로 출력할 변수 
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
	
	int yoNum = target.get(Calendar.DAY_OF_WEEK); // 일이 1 월 2 , 토 7 
	System.out.println(yoNum);
	//시작공백의 개수 : 일요일 공백 x, 월요일은 1칸, ... 토요일은 6칸 -> yoNum-1이 공백의 개수
	int startBlank = yoNum - 1; // endBlank는 의미없음 
	int lastDate = target.getActualMaximum(Calendar.DATE); // target달의 마지막 날짜 변환
	System.out.println(lastDate);
	int countDiv = startBlank + lastDate;
	
	// DB에서 tYear와 tMonth에 해당되는 diary 목록을 추출한다.
	
	String sql2 = "select diary_date diaryDate, day(diary_date) day,left(title,5), feeling, title from diary where year(diary_date)=? and month(diary_date)=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1,tYear);
	stmt2.setInt(2,tMonth+1);
	System.out.println(stmt2);
	
	rs2 = stmt2.executeQuery();
	
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
		.cell{
			float: left;
			background-color: rgba(67,116,217,0.5);
			width: 70px; height:70px;
			border:0.2px solid white;
			border-radius:6px;
			text-align: center;
			margin: 3px;
		
		}
	
		.sun {
			clear: both;
			color: #FF0000;
		}
		.sat{
			clear: both;
			color : #0054FF;
		}
		.yo{
			float: left;
			width: 66px; height: 20px;
			
			border-radius:2px;
			margin: 5px;
			text-align: center;
			color: white;
		}
		.ma{
			margin-left: 450px;
			text-align: center;
			margin-top:40px;
		}
		.te{
			margin-right:770px;
		}	
		
		a:hover{color:white; text-decoration:none;}	
		a.groove{border-style: groove; }
		a.active{color:white; text-decoration:none;}
	   	.na {
			font-family: "Nanum Pen Script", cursive;
			font-weight: 400;
			font-style: normal;
		}
		hr{
		margin-right: 700px;
		}	

	</style>
</head>
	
<body class = "ma na container text-white " style = "background-size:100%;background-image:url(/diary/img/sea.jpg) ">

	<div >
		<div class = "te">
			<h1>일기장</h1>
			<span>
				<a href = "/diary/addDiaryForm.jsp" class="btn btn-outline-light">일기쓰기</a>
			</span>
			<span>
				<a href = "/diary/logout.jsp" class="btn btn-outline-light">로그아웃</a>
			</span>
			<div>
				<a href="/diary/diary.jsp" class = "text-white">다이어리 모양으로 보기</a>
				<a href="/diary/diaryList.jsp" class = "text-white">게시판 모양으로 보기</a>
			</div>
		</div>
	</div>
	<hr>
	<h1 class = "te"><%=tYear %>년 <%=tMonth+1 %>월</h1>
		<div class = "te">
			<span><a href = "/diary/diary.jsp?targetYear=<%=tYear %>&targetMonth=<%=tMonth - 1%>" class="btn btn-outline-light ">이전달</a></span>
			<span><a href = "/diary/diary.jsp?targetYear=<%=tYear %>&targetMonth=<%=tMonth+1%>" class="btn btn-outline-light">다음달</a></span>		
		</div>
		<div>
		</div>
		<br>
		<!-- 월화수목금토일 -->
		
		<div class="yo">SUN</div>
		<div class="yo">MON</div>
		<div class="yo">TUE</div>
		<div class="yo">WED</div>
		<div class="yo">THU</div>
		<div class="yo">FRI</div>
		<div class="yo">SAT</div>
<%
		for (int i = 1; i<=countDiv;i++){
			if(i%7==1){
%>				
			<div class = "cell sun" style = "text-align:center; ">
<%			
			}else if(i%7==0){
%>				
			<div style = "color: #0033FF;" class = "cell">
<%			
			}else{
%>			
			<div class = "cell" style = "text-align:center;">
<% 			
			}
%>				
<% 	
			if(i-startBlank>0){
 		%>
 				<%=i-startBlank %><br>
 		<% 
 				//현재날짜(i-startBlank)의 일기가 rs2목록에 있는지 비교
 				while(rs2.next()){
 					//날짜에 일기가 존재한다.
 					if(rs2.getInt("day")==(i-startBlank)){
 		%>
 						<div >
 							<span><%=rs2.getString("feeling") %></span>
 							<a href = '/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>' class="text-white">
 							<%=rs2.getString("title")%>...
 							</a>
 						</div>
 		<%				
 						break;
 					}
 				}
 				rs2.beforeFirst(); // Resultset의 커서 위치를 처음으로 보내주는 api
			}	else{ 
		%>
					&nbsp;		
		<%
			}	
		%>	
		</div>		
		<% 		
			}
		%>
	</div>
	</div>

</body>
</html>