<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import="java.net.*"%>
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

<%	String checkDate = request.getParameter("checkDate");
	
	String sql2 = "select lunch_date lunchDate from lunch where lunch_date=?";
	// 결과가 있으면 이미 이날짜에 일기가 있다 -> 이 날짜로는 입력 x
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,checkDate);
	rs2 = stmt2.executeQuery();
	if(rs2.next()) {
		// 이날짜 일기 기록 불가능(이미 존재)	
		response.sendRedirect("/diary/lunchOne.jsp?checkDate="+checkDate+"&ck=F");
	} else{
		// 이날짜 일기 기록 가능
		response.sendRedirect("/diary/lunchOne.jsp?checkDate="+checkDate+"&ck=T");
	}
	
	
	

%>

