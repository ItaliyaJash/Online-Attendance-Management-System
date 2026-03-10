<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.ClassRoom" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    List<ClassRoom> classes = (List<ClassRoom>) request.getAttribute("classes");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Student — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="navbar">
    <h2>🎓 OAMS — Admin Panel</h2>
    <div class="nav-links">
        <a href="../admin/dashboard">Dashboard</a>
        <a href="../admin/viewStudents">View Students</a>
        <a href="../logout" class="btn-logout">Logout</a>
    </div>
</div>
<div class="container">
    <h1>Add New Student</h1>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>
    <form action="../admin/addStudent" method="post" class="form-box">
        <div class="form-group">
            <label>Roll Number</label>
            <input type="text" name="rollNo" required placeholder="e.g. CS2024001">
        </div>
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="name" required placeholder="Student full name">
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required placeholder="student@college.edu">
        </div>
        <div class="form-group">
            <label>Department</label>
            <input type="text" name="department" required placeholder="e.g. Computer Science">
        </div>
        <div class="form-group">
            <label>Semester</label>
            <select name="semester" required>
                <option value="">Select Semester</option>
                <% for (int i = 1; i <= 8; i++) { %>
                    <option value="<%= i %>">Semester <%= i %></option>
                <% } %>
            </select>
        </div>
        <div class="form-group">
            <label>Class</label>
            <select name="classId" required>
                <option value="">Select Class</option>
                <% if (classes != null) {
                    for (ClassRoom c : classes) { %>
                    <option value="<%= c.getClassId() %>"><%= c.getClassName() %> — <%= c.getDepartment() %></option>
                <%  } } %>
            </select>
        </div>
        <div class="form-group">
            <label>Username (for login)</label>
            <input type="text" name="username" required placeholder="Login username">
        </div>
        <div class="form-group">
            <label>Password (for login)</label>
            <input type="password" name="password" required placeholder="Login password">
        </div>
        <button type="submit" class="btn btn-primary">Add Student</button>
    </form>
</div>
</body>
</html>
