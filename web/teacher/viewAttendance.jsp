<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, model.Subject, model.Attendance" %>
<%
    if (!"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized"); return;
    }
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    List<Subject>        subjects  = (List<Subject>)        request.getAttribute("subjects");
    List<Attendance>     records   = (List<Attendance>)     request.getAttribute("records");
    Map<Integer,String>  sNames    = (Map<Integer,String>)  request.getAttribute("studentNames");
    Map<Integer,String>  sRolls    = (Map<Integer,String>)  request.getAttribute("studentRolls");
    String selSubject = (String) request.getAttribute("selectedSubjectId");
    String selDate    = (String) request.getAttribute("selectedDate");
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Attendance — OAMS</title>
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
    <h1>View Attendance Records</h1>

    <%-- Success messages shown after marking or updating attendance --%>
    <% String suc = request.getParameter("success");
       if ("marked" .equals(suc)) { %><div class="alert alert-success">Attendance marked successfully!</div><% }
       if ("updated".equals(suc)) { %><div class="alert alert-success">Attendance updated successfully!</div><% } %>

    <%-- Filter form: teacher selects a subject and date to search --%>
    <form action="../teacher/viewAttendance" method="get" class="form-box" style="margin-bottom:26px;">
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;">
            <div class="form-group">
                <label>Subject</label>
                <select name="subjectId" required>
                    <option value="">Select Subject</option>
                    <% if (subjects != null) for (Subject s : subjects) { %>
                    <option value="<%= s.getSubjectId() %>"
                        <%= (selSubject != null && selSubject.equals(String.valueOf(s.getSubjectId()))) ? "selected" : "" %>>
                        <%= s.getSubjectName() %>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>Date</label>
                <input type="date" name="date" required
                       value="<%= selDate != null ? selDate : "" %>">
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Search</button>
    </form>

    <%-- Show results only if the servlet set the records attribute --%>
    <% if (records != null) { %>

        <% if (!records.isEmpty()) { %>

            <%--
                FIX: Declare pCount ONCE here at the top of this block.
                The original code declared it again inside the summary div,
                which caused "Duplicate local variable pCount" compile error.
            --%>
            <%
                int pCount = 0;
                for (Attendance a : records) {
                    if ("Present".equals(a.getStatus())) pCount++;
                }
            %>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Roll No</th>
                        <th>Student Name</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <% int no = 1;
                   for (Attendance a : records) { %>
                    <tr>
                        <td><%= no++ %></td>
                        <td><%= sRolls != null ? sRolls.get(a.getStudentId()) : "" %></td>
                        <td><%= sNames != null ? sNames.get(a.getStudentId()) : "" %></td>
                        <td>
                            <span class="<%= "Present".equals(a.getStatus()) ? "badge-present" : "badge-absent" %>">
                                <%= a.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <%-- Inline update form per row — posts to UpdateAttendanceServlet --%>
                            <form action="../teacher/updateAttendance" method="post"
                                  style="display:inline-flex;gap:6px;align-items:center;">
                                <input type="hidden" name="attendanceId" value="<%= a.getAttendanceId() %>">
                                <input type="hidden" name="subjectId"    value="<%= selSubject %>">
                                <input type="hidden" name="date"         value="<%= selDate %>">
                                <select name="status" style="padding:5px;border-radius:4px;border:1px solid #ccc;">
                                    <option value="Present" <%= "Present".equals(a.getStatus()) ? "selected" : "" %>>Present</option>
                                    <option value="Absent"  <%= "Absent" .equals(a.getStatus()) ? "selected" : "" %>>Absent</option>
                                </select>
                                <button type="submit" class="btn btn-primary"
                                        style="padding:5px 12px;font-size:13px;">Update</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>

            <%-- Summary bar — uses pCount already calculated above (no redeclaration) --%>
            <div style="margin-top:13px;color:#555;font-size:14px;">
                <strong>Summary:</strong>
                Total: <%= records.size() %> &nbsp;|&nbsp;
                <span style="color:#2e7d32;">Present: <%= pCount %></span> &nbsp;|&nbsp;
                <span style="color:#c62828;">Absent: <%= records.size() - pCount %></span>
            </div>

        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr><th>#</th><th>Roll No</th><th>Student Name</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="5" style="text-align:center;color:#888;">
                            No records found for this date.
                        </td>
                    </tr>
                </tbody>
            </table>
        <% } %>

    <% } %>
</div>
</body>
</html>
