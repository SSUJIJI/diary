<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
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

	String sql2 = "select menu, count(*) cnt from lunch group by menu";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection(
		"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
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
	<a href="/diary/diary.jsp" class = "text-white">다이어리로 돌아가기</a>
	<h1>투표 결과</h1>
	
	<%
				double maxHeight = 500;
				double totalCnt = 0; //
				while(rs2.next()) {
					totalCnt = totalCnt + rs2.getInt("cnt");
				}
				
				rs2.beforeFirst();
	%>
	<div >
		전체 투표수 : <%=(int)totalCnt%>
	</div>
	<div  class="opacity-75 text-align: center;"  >
	<table border="1" style="width: 300px;  margin: auto;"  >
		<tr>
			<%	
				String[] c = {"#B2CCFF", "#6799FF", "#4374D9", "#003399", "#002266"};
				int i = 0;
				while(rs2.next()) {
					int h = (int)(maxHeight * (rs2.getInt("cnt")/totalCnt));
			%>
					<td style="vertical-align: bottom;">
						<div style="height: <%=h%>px; 
									background-color:<%=c[i]%>;
									text-align: center">
							<%=rs2.getInt("cnt")%>
						</div>
					</td>
			<%		
					i = i+1;
				}
			%>
		</tr>
		<tr>
			<%
				// 커스의 위치를 다시 처음으로
				rs2.beforeFirst();
							
				while(rs2.next()) {
			%>
					<td><%=rs2.getString("menu")%></td>
			<%		
				}
			%>
		</tr>
	</table>
	</div>
	
	
	
</body>
</html>
​
