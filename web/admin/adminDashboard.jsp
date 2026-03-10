<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache"); response.setDateHeader("Expires",0);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="navbar">
    <h2>🎓 OAMS — Admin Panel</h2>
    <div class="nav-links">
        <a href="../admin/dashboard">Dashboard</a>
        <a href="../admin/addTeacher">Add Teacher</a>
        <a href="../admin/viewTeachers">Teachers</a>
        <a href="../admin/addStudent">Add Student</a>
        <a href="../admin/viewStudents">Students</a>
        <a href="../admin/addClass">Add Class</a>
        <a href="../admin/addSubject">Add Subject</a>
        <a href="../logout" class="btn-logout">Logout</a>
    </div>
</div>
<div class="container">
    <h1>Welcome, Admin!</h1>
    <% if (request.getParameter("success") != null) { %>
        <div class="alert alert-success">Operation completed successfully!</div>
    <% } %>
    <div class="dashboard-cards">
        <div class="card card-blue">
            <h3>Total Students</h3>
            <p class="card-number"><%= request.getAttribute("totalStudents") %></p>
            <a href="../admin/viewStudents">View All →</a>
        </div>
        <div class="card card-green">
            <h3>Total Teachers</h3>
            <p class="card-number"><%= request.getAttribute("totalTeachers") %></p>
            <a href="../admin/viewTeachers">View All →</a>
        </div>
        <div class="card card-orange">
            <h3>Total Classes</h3>
            <p class="card-number"><%= request.getAttribute("totalClasses") %></p>
            <a href="../admin/addClass">Add New →</a>
        </div>
        <div class="card card-purple">
            <h3>Total Subjects</h3>
            <p class="card-number"><%= request.getAttribute("totalSubjects") %></p>
            <a href="../admin/addSubject">Add New →</a>
        </div>
    </div>
</div>
</body>
</html>
