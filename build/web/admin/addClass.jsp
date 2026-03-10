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
    <title>Add Class — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="navbar">
    <h2>🎓 OAMS — Admin Panel</h2>
    <div class="nav-links">
        <a href="../admin/dashboard">Dashboard</a>
        <a href="../logout" class="btn-logout">Logout</a>
    </div>
</div>
<div class="container">
    <h1>Add New Class</h1>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>
    <form action="../admin/addClass" method="post" class="form-box">
        <div class="form-group">
            <label>Class Name</label>
            <input type="text" name="className" required placeholder="e.g. CS-A">
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
        <button type="submit" class="btn btn-primary">Add Class</button>
    </form>
</div>
</body>
</html>
