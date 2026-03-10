<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Subject" %>
<%
    if (!"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache"); response.setDateHeader("Expires",0);
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Teacher Dashboard — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="navbar">
    <h2>🎓 OAMS — Teacher Panel</h2>
    <div class="nav-links">
        <a href="../teacher/dashboard">Dashboard</a>
        <a href="../teacher/takeAttendance">Take Attendance</a>
        <a href="../teacher/viewAttendance">View Attendance</a>
        <a href="../report">Reports</a>
        <a href="../logout" class="btn-logout">Logout</a>
    </div>
</div>
<div class="container">
    <h1>Welcome, <%= session.getAttribute("username") %>!</h1>
    <div class="dashboard-cards">
        <div class="card card-blue">
            <h3>My Subjects</h3>
            <p class="card-number"><%= subjects != null ? subjects.size() : 0 %></p>
        </div>
        <div class="card card-green">
            <h3>Take Attendance</h3>
            <p style="margin-top:12px;">
                <a href="../teacher/takeAttendance" class="btn btn-primary" style="color:white;text-decoration:none;">Mark Now →</a>
            </p>
        </div>
        <div class="card card-orange">
            <h3>View Records</h3>
            <p style="margin-top:12px;">
                <a href="../teacher/viewAttendance" class="btn" style="background:#ef6c00;color:white;text-decoration:none;">View →</a>
            </p>
        </div>
        <div class="card card-purple">
            <h3>Reports</h3>
            <p style="margin-top:12px;">
                <a href="../report" class="btn" style="background:#7b1fa2;color:white;text-decoration:none;">Generate →</a>
            </p>
        </div>
    </div>

    <h2 class="section-title">My Assigned Subjects</h2>
    <table class="data-table">
        <thead>
            <tr><th>Subject ID</th><th>Subject Name</th><th>Department</th><th>Semester</th></tr>
        </thead>
        <tbody>
            <% if (subjects != null && !subjects.isEmpty()) {
                for (Subject s : subjects) { %>
            <tr>
                <td><%= s.getSubjectId() %></td>
                <td><%= s.getSubjectName() %></td>
                <td><%= s.getDepartment() %></td>
                <td><%= s.getSemester() %></td>
            </tr>
            <% } } else { %>
            <tr><td colspan="4" style="text-align:center;color:#888;">No subjects assigned yet.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
