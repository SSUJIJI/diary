<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@page import="java.net.*"%>
<%

	//로그인(인증) 분기
	// diary.login.my_session -> "ON"일때만 redirect("diary.jsp") <-- db설정하는 것
	
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
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
	if(mySession.equals("ON")) {
		response.sendRedirect("/diary/diary.jsp"); // <-get 방식
		// db자원반납 (return전에)
		rs1.close();
		stmt1.close();
		conn.close();
		return; //코드 진행을 끝냄 ex)메소드 끝낼 때 return사용
	}
	//1. 요청값 분석
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	String sql2= "select member_id memberId From member where member_id=? and member_pw = ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	rs2 = stmt2.executeQuery();
	
	
	if(rs2.next()){
		//로그인 성공
		//diary.login.my_session -> "ON" 변경 (update쿼리 만들어야함)-> update my_session = 'ON'
		System.out.println("로그인 성공");
		String sql3 = "update login set my_session = 'ON',on_date = now() where my_session='OFF'";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		int row = stmt3.executeUpdate();
		System.out.println(row + "<-row");
		response.sendRedirect("/diary/diary.jsp");
		
	} else{
		//로그인 실패
		System.out.println("로그인 실패");
		String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요.","utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	}
	
	rs1.close();
	stmt1.close();
	
	rs2.close();
	stmt2.close();
	
	conn.close();
	
%>
