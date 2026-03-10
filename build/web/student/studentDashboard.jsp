<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Student" %>
<%
    if (!"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache"); 
    response.setDateHeader("Expires",0);
    Student student = (Student) request.getAttribute("student");
    String  pct     = (String)  request.getAttribute("overallPercentage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .welcome-box{background:linear-gradient(135deg,#1a237e,#283593);color:white;padding:28px 30px;border-radius:12px;margin-bottom:26px;}
        .welcome-box h1{font-size:26px;margin-bottom:6px;}
        .welcome-box p{opacity:0.85;font-size:15px;}
        .quick-links{display:flex;gap:16px;margin-top:24px;}
        .q-link{flex:1;background:white;border-radius:10px;padding:20px;text-align:center;box-shadow:0 2px 10px rgba(0,0,0,0.07);text-decoration:none;color:#333;transition:transform 0.2s,box-shadow 0.2s;}
        .q-link:hover{transform:translateY(-3px);box-shadow:0 5px 18px rgba(0,0,0,0.12);}
        .q-link .icon{font-size:28px;margin-bottom:8px;}
        .q-link p{font-size:12px;color:#888;margin-top:4px;}
    </style>
</head>
<body>
<div class="navbar">
    <h2>🎓 OAMS — Student Panel</h2>
    <div class="nav-links">
        <a href="../student/dashboard">Dashboard</a>
        <a href="../student/viewMyAttendance">My Attendance</a>
        <a href="../student/profile">My Profile</a>
        <a href="../logout" class="btn-logout">Logout</a>
    </div>
</div>
<div class="container">
    <div class="welcome-box">
        <h1 style="color: #ffffff">Welcome, <%= student != null ? student.getName() : session.getAttribute("username") %>!</h1>
        <p>
            Roll No: <strong><%= student != null ? student.getRollNo() : "N/A" %></strong> &nbsp;|&nbsp;
            Dept: <strong><%= student != null ? student.getDepartment() : "N/A" %></strong> &nbsp;|&nbsp;
            Semester: <strong><%= student != null ? student.getSemester() : "N/A" %></strong>
        </p>
    </div>

    <div class="dashboard-cards">
        <div class="card card-purple">
            <h3>Overall Attendance</h3>
            <p class="card-number" style="color:#7b1fa2;"><%= pct %>%</p>
        </div>
        <div class="card card-blue">
            <h3>Total Classes</h3>
            <p class="card-number"><%= request.getAttribute("totalClasses") %></p>
        </div>
        <div class="card card-green">
            <h3>Present</h3>
            <p class="card-number" style="color:#2e7d32;"><%= request.getAttribute("presentCount") %></p>
        </div>
        <div class="card" style="border-top:4px solid #e53935;">
            <h3>Absent</h3>
            <p class="card-number" style="color:#e53935;"><%= request.getAttribute("absentCount") %></p>
        </div>
    </div>

    <div class="quick-links">
        <a href="../student/viewMyAttendance" class="q-link">
            <div class="icon">📊</div>
            <strong>Detailed Attendance</strong>
            <p>Subject-wise breakdown</p>
        </a>
        <a href="../student/profile" class="q-link">
            <div class="icon">👤</div>
            <strong>My Profile</strong>
            <p>View personal details</p>
        </a>
    </div>
</div>
</body>
</html>
