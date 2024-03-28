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
	//if문에 안 걸릴 때는 현재값이 OFF가 아니고 ON이다. -> OFF로 변경후 loginForm으로 redirect
	
	String checkDate = request.getParameter("checkDate");
	
	String sql2 = "select lunch_date lunchDate from lunch where lunch_date=?";
	// 결과가 있으면 이미 이날짜에 일기가 있다 -> 이 날짜로는 입력 x
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

