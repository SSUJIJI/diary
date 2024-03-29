<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@page import="java.net.*"%>
<%
	// 0. 로그인(인증)분기
		String loginMember = (String)(session.getAttribute("loginMember"));
	// session.getAttribute()는 찾는 변수가 없으면 null값을 반환한다. why? 로그인을 한 적이 없으니까.
	// loginMember가 null이면 로그아웃상태, 아니면 로그인 상태 
	System.out.println(loginMember + "<-loginMember");
	
	// loginForm페이지는 로그아웃상태에서만 출력된다.
	//if문으로 loginMember가 null일 때, 아닐 때 구분
	
	if(loginMember != null){
		response.sendRedirect("/diary/diary/jsp");
		return;
	} 
	
	// loginMember가 null이다. -> session 공간에 loginMember 변수를 생성하고 
%>
<%
	//1. 요청값 분석 -> 로그인 성공 -> session에 loginMember변수를 생성 
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	String sql2= "select member_id memberId From member where member_id=? and member_pw = ?";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt2 = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	rs2 = stmt2.executeQuery();
	
	
	if(rs2.next()){
		//로그인 성공
		//diary.login.my_session -> "ON" 변경 (update쿼리 만들어야함)-> update my_session = 'ON'
		System.out.println("로그인 성공");
		/*
		String sql3 = "update login set my_session = 'ON',on_date = now() where my_session='OFF'";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		int row = stmt3.executeUpdate();
		System.out.println(row + "<-row");
		*/
		//로그인 성공시 DB값 설정 -> session변수 설정
		session.setAttribute("loginMember", rs2.getString("memberId"));
		
		response.sendRedirect("/diary/diary.jsp");
		
	} else{
		//로그인 실패
		System.out.println("로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요.","utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	}
	
	
%>
