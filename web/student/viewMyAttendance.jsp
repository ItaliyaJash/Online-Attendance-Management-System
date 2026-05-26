<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, model.Attendance" %>
<%
    if (!"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized");
        return;
    }
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    List<Map<String, String>> summary = (List<Map<String, String>>) request.getAttribute("subjectSummary");
    List<Attendance> filtered = (List<Attendance>) request.getAttribute("filteredRecords");
    Map<Integer, String> sNames = (Map<Integer, String>) request.getAttribute("subjectNames");
    String selSub = (String) request.getAttribute("selectedSubjectId");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>My Attendance — OAMS</title>
        <link rel="stylesheet" href="../css/style.css">
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
            <h1>My Attendance</h1>

            <!-- Subject-wise Summary -->
            <h2 class="section-title">📚 Subject-wise Summary</h2>
            <% if (summary != null && !summary.isEmpty()) { %>
            <table class="data-table">
                <thead>
                    <tr><th>Subject</th><th>Total</th><th>Present</th><th>Absent</th><th>Percentage</th><th>Progress</th><th>Status</th><th></th></tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> row : summary) {
                            double pct = Double.parseDouble(row.get("percentage"));
                            String bar = pct >= 75 ? "progress-green" : pct >= 50 ? "progress-yellow" : "progress-red";
                    %>
                    <tr>
                        <td><strong><%= row.get("subjectName")%></strong></td>
                        <td><%= row.get("total")%></td>
                        <td style="color:#2e7d32;"><%= row.get("present")%></td>
                        <td style="color:#c62828;"><%= row.get("absent")%></td>
                        <td><strong><%= row.get("percentage")%>%</strong></td>
                        <td style="min-width:110px;">
                            <div class="progress-bar">
                                <div class="progress-fill <%= bar%>" style="width:<%= row.get("percentage")%>%"></div>
                            </div>
                        </td>
                        <td><span class="<%= "OK".equals(row.get("status")) ? "badge-ok" : "badge-low"%>">
                                <%= "OK".equals(row.get("status")) ? "✓ OK" : "⚠ Low"%>
                            </span></td>
                        <td>
                            <a href="../student/viewMyAttendance?subjectId=<%= row.get("subjectId")%>"
                               class="btn btn-primary" style="padding:5px 12px;font-size:12px;text-decoration:none;color:white;">Details</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="alert alert-error">No attendance records found yet.</div>
            <% } %>

            <!-- Day-wise drill-down -->
            <% if (filtered != null) {
                    String subjectLabel = (sNames != null && selSub != null) ? sNames.getOrDefault(Integer.parseInt(selSub), "Subject") : "Subject";
            %>
            <h2 class="section-title">📅 Day-wise — <%= subjectLabel%></h2>
            <div style="margin-bottom:14px;">
                <a href="../student/viewMyAttendance" style="color:#1a237e;font-size:14px;">← Back to Summary</a>
            </div>
            <table class="data-table">
                <thead>
                    <tr><th>#</th><th>Date</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <% if (!filtered.isEmpty()) {
                int no = 1;
                for (Attendance a : filtered) {%>
                    <tr>
                        <td><%= no++%></td>
                        <td><%= a.getDate()%></td>
                        <td><span class="<%= "Present".equals(a.getStatus()) ? "badge-present" : "badge-absent"%>"><%= a.getStatus()%></span></td>
                    </tr>
                    <%  }
        } else { %>
                    <tr><td colspan="3" style="text-align:center;color:#888;">No records found.</td></tr>
                    <% } %>
                </tbody>
            </table>
            <%
                int fp = 0;
                for (Attendance a : filtered) {
                    if ("Present".equals(a.getStatus())) {
                        fp++;
                    }
                }
                double fpct = filtered.size() > 0 ? (fp * 100.0) / filtered.size() : 0;
            %>
            <div style="margin-top:14px;padding:14px 18px;background:white;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.06);font-size:14px;">
                <strong>Summary:</strong> Total: <%= filtered.size()%> |
                <span style="color:#2e7d32;">Present: <%= fp%></span> |
                <span style="color:#c62828;">Absent: <%= filtered.size() - fp%></span> |
                <strong>Percentage: <%= String.format("%.1f", fpct)%>%</strong>
                <% if (fpct < 75) { %>
                <span style="color:#c62828;margin-left:12px;">⚠ Attendance below 75% — please attend more classes!</span>
                <% } %>
            </div>
            <% }%>
        </div>
    </body>
</html>
