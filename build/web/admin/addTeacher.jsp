<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Teacher — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="navbar">
    <h2>🎓 OAMS — Admin Panel</h2>
    <div class="nav-links">
        <a href="../admin/dashboard">Dashboard</a>
        <a href="../admin/viewTeachers">View Teachers</a>
        <a href="../logout" class="btn-logout">Logout</a>
    </div>
</div>
<div class="container">
    <h1>Add New Teacher</h1>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>
    <form action="../admin/addTeacher" method="post" class="form-box">
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="name" required placeholder="e.g. Prof. Rajesh Kumar">
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required placeholder="teacher@college.edu">
        </div>
        <div class="form-group">
            <label>Phone</label>
            <input type="text" name="phone" required placeholder="10-digit mobile number">
        </div>
        <div class="form-group">
            <label>Department</label>
            <input type="text" name="department" required placeholder="e.g. Computer Science">
        </div>
        <div class="form-group">
            <label>Username (for login)</label>
            <input type="text" name="username" required placeholder="Login username">
        </div>
        <div class="form-group">
            <label>Password (for login)</label>
            <input type="password" name="password" required placeholder="Login password">
        </div>
        <button type="submit" class="btn btn-primary">Add Teacher</button>
    </form>
</div>
</body>
</html>
