<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Student" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    List<Student> students = (List<Student>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Students — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="navbar">
    <h2>🎓 OAMS — Admin Panel</h2>
    <div class="nav-links">
        <a href="../admin/dashboard">Dashboard</a>
        <a href="../admin/addStudent">Add Student</a>
        <a href="../logout" class="btn-logout">Logout</a>
    </div>
</div>
<div class="container">
    <h1>All Students</h1>
    <% if ("added".equals(request.getParameter("success"))) { %>
        <div class="alert alert-success">Student added successfully!</div>
    <% } %>
    <table class="data-table">
        <thead>
            <tr><th>ID</th><th>Roll No</th><th>Name</th><th>Email</th><th>Department</th><th>Semester</th><th>Class ID</th></tr>
        </thead>
        <tbody>
            <% if (students != null && !students.isEmpty()) {
                for (Student s : students) { %>
            <tr>
                <td><%= s.getStudentId() %></td>
                <td><%= s.getRollNo() %></td>
                <td><%= s.getName() %></td>
                <td><%= s.getEmail() %></td>
                <td><%= s.getDepartment() %></td>
                <td><%= s.getSemester() %></td>
                <td><%= s.getClassId() %></td>
            </tr>
            <% } } else { %>
            <tr><td colspan="7" style="text-align:center;color:#888;">No students found.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
