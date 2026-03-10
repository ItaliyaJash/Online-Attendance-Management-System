<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Subject, model.Student, model.ClassRoom" %>
<%
    if (!"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    List<Subject>   subjects  = (List<Subject>)   request.getAttribute("subjects");
    List<ClassRoom> classes   = (List<ClassRoom>) request.getAttribute("classes");
    List<Student>   students  = (List<Student>)   request.getAttribute("students");
    String selSubject = (String) request.getAttribute("selectedSubjectId");
    String selClass   = (String) request.getAttribute("selectedClassId");
    String selDate    = (String) request.getAttribute("selectedDate");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Take Attendance — OAMS</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .radio-grp{display:flex;gap:18px;}
        .radio-grp label{cursor:pointer;padding:4px 10px;border-radius:4px;}
        .lbl-p{color:#2e7d32;font-weight:600;}
        .lbl-a{color:#c62828;font-weight:600;}
    </style>
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
    <h1>Take Attendance</h1>

    <!-- STEP 1: Select subject, class, date -->
    <form action="../teacher/takeAttendance" method="get" class="form-box" style="margin-bottom:28px;">
        <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px;">
            <div class="form-group">
                <label>Subject</label>
                <select name="subjectId" required>
                    <option value="">Select Subject</option>
                    <% if (subjects != null) for (Subject s : subjects) { %>
                    <option value="<%= s.getSubjectId() %>" <%= (selSubject != null && selSubject.equals(String.valueOf(s.getSubjectId()))) ? "selected" : "" %>>
                        <%= s.getSubjectName() %>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>Class</label>
                <select name="classId" required>
                    <option value="">Select Class</option>
                    <% if (classes != null) for (ClassRoom c : classes) { %>
                    <option value="<%= c.getClassId() %>" <%= (selClass != null && selClass.equals(String.valueOf(c.getClassId()))) ? "selected" : "" %>>
                        <%= c.getClassName() %> — <%= c.getDepartment() %>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>Date</label>
                <input type="date" name="date" required value="<%= selDate != null ? selDate : "" %>">
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Load Students</button>
    </form>

    <!-- STEP 2: Mark attendance -->
    <% if (students != null && !students.isEmpty()) { %>
    <form action="../teacher/takeAttendance" method="post">
        <input type="hidden" name="subjectId" value="<%= selSubject %>">
        <input type="hidden" name="date"      value="<%= selDate %>">
        <table class="data-table">
            <thead>
                <tr><th>#</th><th>Roll No</th><th>Student Name</th><th>Status</th></tr>
            </thead>
            <tbody>
                <% int no = 1; for (Student s : students) { %>
                <tr>
                    <td><%= no++ %></td>
                    <td><%= s.getRollNo() %></td>
                    <td><%= s.getName() %></td>
                    <td>
                        <input type="hidden" name="studentId" value="<%= s.getStudentId() %>">
                        <div class="radio-grp">
                            <label class="lbl-p">
                                <input type="radio" name="status_<%= s.getStudentId() %>" value="Present" checked> Present
                            </label>
                            <label class="lbl-a">
                                <input type="radio" name="status_<%= s.getStudentId() %>" value="Absent"> Absent
                            </label>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <div style="margin-top:18px;display:flex;gap:12px;">
            <button type="submit" class="btn btn-primary">Submit Attendance</button>
            <button type="button" class="btn" style="background:#e8f5e9;color:#2e7d32;" onclick="markAll('Present')">✓ All Present</button>
            <button type="button" class="btn" style="background:#ffebee;color:#c62828;" onclick="markAll('Absent')">✗ All Absent</button>
        </div>
    </form>
    <script>
        function markAll(status) {
            document.querySelectorAll('input[type="radio"][value="'+status+'"]')
                    .forEach(r => r.checked = true);
        }
    </script>
    <% } else if (selSubject != null) { %>
        <div class="alert alert-error">No students found for the selected class.</div>
    <% } %>
</div>
</body>
</html>
