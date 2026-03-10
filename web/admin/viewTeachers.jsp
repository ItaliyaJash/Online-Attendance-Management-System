<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Teacher" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    List<Teacher> teachers = (List<Teacher>) request.getAttribute("teachers");
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Teachers — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="navbar">
    <h2>🎓 OAMS — Admin Panel</h2>
    <div class="nav-links">
        <a href="../admin/dashboard">Dashboard</a>
        <a href="../admin/addTeacher">Add Teacher</a>
        <a href="../logout" class="btn-logout">Logout</a>
    </div>
</div>
<div class="container">
    <h1>All Teachers</h1>
    <% if ("added".equals(request.getParameter("success"))) { %>
        <div class="alert alert-success">Teacher added successfully!</div>
    <% } %>
    <table class="data-table">
        <thead>
            <tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Department</th><th>Username</th></tr>
        </thead>
        <tbody>
            <% if (teachers != null && !teachers.isEmpty()) {
                for (Teacher t : teachers) { %>
            <tr>
                <td><%= t.getTeacherId() %></td>
                <td><%= t.getName() %></td>
                <td><%= t.getEmail() %></td>
                <td><%= t.getPhone() %></td>
                <td><%= t.getDepartment() %></td>
                <td><%= t.getUsername() %></td>
            </tr>
            <% } } else { %>
            <tr><td colspan="6" style="text-align:center;color:#888;">No teachers found.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
