<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Student, model.ClassRoom" %>
<%
    if (!"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    Student   student   = (Student)   request.getAttribute("student");
    ClassRoom classRoom = (ClassRoom) request.getAttribute("classRoom");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .profile-card{background:white;border-radius:12px;box-shadow:0 4px 16px rgba(0,0,0,0.09);max-width:580px;overflow:hidden;}
        .profile-header{background:linear-gradient(135deg,#1a237e,#283593);color:white;padding:30px;text-align:center;}
        .profile-avatar{width:76px;height:76px;border-radius:50%;background:rgba(255,255,255,0.2);display:flex;align-items:center;justify-content:center;font-size:34px;margin:0 auto 12px;border:3px solid rgba(255,255,255,0.4);}
        .profile-header h2{margin-bottom:4px;}
        .profile-header p{opacity:0.8;font-size:14px;}
        .profile-body{padding:22px 28px;}
        .profile-row{display:flex;justify-content:space-between;padding:11px 0;border-bottom:1px solid #f0f0f0;font-size:14px;}
        .profile-row:last-child{border-bottom:none;}
        .profile-label{font-weight:600;color:#666;}
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
    <h1>My Profile</h1>
    <% if (student != null) { %>
    <div class="profile-card">
        <div class="profile-header">
            <div class="profile-avatar">👨‍🎓</div>
            <h2><%= student.getName() %></h2>
            <p>Roll No: <%= student.getRollNo() %></p>
        </div>
        <div class="profile-body">
            <div class="profile-row"><span class="profile-label">Student ID</span><span><%= student.getStudentId() %></span></div>
            <div class="profile-row"><span class="profile-label">Full Name</span><span><%= student.getName() %></span></div>
            <div class="profile-row"><span class="profile-label">Roll Number</span><span><%= student.getRollNo() %></span></div>
            <div class="profile-row"><span class="profile-label">Email</span><span><%= student.getEmail() %></span></div>
            <div class="profile-row"><span class="profile-label">Department</span><span><%= student.getDepartment() %></span></div>
            <div class="profile-row"><span class="profile-label">Semester</span><span><%= student.getSemester() %></span></div>
            <div class="profile-row"><span class="profile-label">Class</span>
                <span><%= classRoom != null ? classRoom.getClassName() + " — " + classRoom.getDepartment() : "N/A" %></span>
            </div>
            <div class="profile-row"><span class="profile-label">Username</span><span><%= student.getUsername() %></span></div>
        </div>
    </div>
    <% } else { %>
        <div class="alert alert-error">Profile not found.</div>
    <% } %>
</div>
</body>
</html>
