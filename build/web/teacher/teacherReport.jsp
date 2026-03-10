<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, model.Subject, model.ClassRoom" %>
<%
    if (!"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=unauthorized");
        return;
    }
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<ClassRoom> classes = (List<ClassRoom>) request.getAttribute("classes");
    List<Map<String, String>> reportData = (List<Map<String, String>>) request.getAttribute("reportData");
    String selSubject = (String) request.getAttribute("selectedSubjectId");
    String selClass = (String) request.getAttribute("selectedClassId");

    /* Pre-calculate summary stats for top cards */
    int totalStudents = 0, okCount = 0, lowCount = 0;
    double totalPct = 0;
    if (reportData != null) {
        totalStudents = reportData.size();
        for (Map<String, String> row : reportData) {
            double p = Double.parseDouble(row.get("percentage"));
            totalPct += p;
            if ("OK".equals(row.get("status"))) {
                okCount++;
            } else {
                lowCount++;
            }
        }
    }
    String avgPct = totalStudents > 0 ? String.format("%.1f", totalPct / totalStudents) : "0.0";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Attendance Report — OAMS</title>
        <link rel="stylesheet" href="../css/style.css">
        <style>

            /* ── GLOBAL ─────────────────────────────────────────────────── */
            body {
                background: #f0f2f8;
                font-family: 'Segoe UI', sans-serif;
            }
            .container {
                max-width: 1100px;
                margin: 0 auto;
                padding: 28px 20px 50px;
            }

            /* ── PAGE BANNER ────────────────────────────────────────────── */
            .page-banner {
                background: linear-gradient(135deg, #0d1557 0%, #1a237e 55%, #3949ab 100%);
                border-radius: 14px;
                padding: 28px 32px;
                margin-bottom: 26px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 6px 24px rgba(13,21,87,0.30);
                color: white;
            }
            .banner-left h1 {
                font-size: 26px;
                margin: 0 0 5px 0;
                color: #fff;
                font-weight: 700;
            }
            .banner-left p  {
                margin: 0;
                font-size: 14px;
                opacity: 0.78;
            }
            .banner-right   {
                font-size: 58px;
                opacity: 0.80;
                line-height: 1;
            }

            /* ── SUMMARY STAT CARDS ─────────────────────────────────────── */
            .stat-row {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 16px;
                margin-bottom: 26px;
            }
            .stat-card {
                background: #fff;
                border-radius: 12px;
                padding: 20px 18px;
                display: flex;
                align-items: center;
                gap: 14px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.07);
                border-left: 5px solid transparent;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .stat-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 24px rgba(0,0,0,0.11);
            }
            .sc-blue   {
                border-color: #1565c0;
            }
            .sc-purple {
                border-color: #6a1b9a;
            }
            .sc-green  {
                border-color: #2e7d32;
            }
            .sc-red    {
                border-color: #c62828;
            }
            .sc-icon   {
                font-size: 32px;
                flex-shrink: 0;
            }
            .sc-num    {
                font-size: 28px;
                font-weight: 800;
                line-height: 1;
                color: #1a237e;
            }
            .sc-num.green  {
                color: #2e7d32;
            }
            .sc-num.red    {
                color: #c62828;
            }
            .sc-num.purple {
                color: #6a1b9a;
            }
            .sc-label  {
                font-size: 12px;
                color: #888;
                margin-top: 4px;
                font-weight: 500;
            }

            /* ── FILTER CARD ────────────────────────────────────────────── */
            .filter-card {
                background: #fff;
                border-radius: 14px;
                padding: 24px 28px 28px;
                margin-bottom: 26px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.07);
                border-top: 4px solid #1a237e;
            }
            .filter-card-title {
                font-size: 15px;
                font-weight: 700;
                color: #1a237e;
                margin-bottom: 18px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .filter-grid {
                display: grid;
                grid-template-columns: 1fr 1fr auto;
                gap: 16px;
                align-items: end;
            }
            .filter-card label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #555;
                margin-bottom: 7px;
            }
            .filter-card select {
                width: 100%;
                padding: 11px 38px 11px 13px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 14px;
                color: #333;
                background: #fafafa;
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 8'%3E%3Cpath fill='%231a237e' d='M1 1l5 5 5-5'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 12px center;
                background-size: 10px;
                transition: border 0.2s, box-shadow 0.2s;
                cursor: pointer;
            }
            .filter-card select:focus {
                border-color: #1a237e;
                background-color: #fff;
                outline: none;
                box-shadow: 0 0 0 3px rgba(26,35,126,0.12);
            }
            .btn-generate {
                padding: 11px 30px;
                background: linear-gradient(135deg, #1a237e, #3949ab);
                color: #fff;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 700;
                cursor: pointer;
                white-space: nowrap;
                box-shadow: 0 3px 10px rgba(26,35,126,0.30);
                transition: opacity 0.2s, transform 0.15s;
            }
            .btn-generate:hover  {
                opacity: 0.88;
            }
            .btn-generate:active {
                transform: scale(0.97);
            }

            /* ── REPORT TABLE CARD ──────────────────────────────────────── */
            .report-wrap {
                background: #fff;
                border-radius: 14px;
                overflow: hidden;
                box-shadow: 0 2px 14px rgba(0,0,0,0.08);
            }
            .report-head {
                background: linear-gradient(135deg, #1a237e, #283593);
                color: #fff;
                padding: 16px 24px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .report-head h3  {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
            }
            .count-pill {
                background: rgba(255,255,255,0.18);
                border: 1px solid rgba(255,255,255,0.30);
                padding: 4px 14px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 600;
            }
            .report-table {
                width: 100%;
                border-collapse: collapse;
            }
            .report-table thead tr {
                background: #f5f7ff;
            }
            .report-table th {
                padding: 13px 18px;
                text-align: left;
                font-size: 12px;
                font-weight: 700;
                color: #1a237e;
                text-transform: uppercase;
                letter-spacing: 0.6px;
                border-bottom: 2px solid #e8eaf6;
            }
            .report-table td {
                padding: 13px 18px;
                font-size: 14px;
                color: #333;
                border-bottom: 1px solid #f0f2f8;
                vertical-align: middle;
            }
            .report-table tbody tr:last-child td {
                border-bottom: none;
            }
            .report-table tbody tr:hover         {
                background: #f8f9ff;
            }

            /* Row number circle */
            .sno {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 30px;
                height: 30px;
                background: #e8eaf6;
                color: #1a237e;
                border-radius: 50%;
                font-size: 12px;
                font-weight: 700;
            }

            /* Roll number chip */
            .roll-chip {
                display: inline-block;
                background: #f5f7ff;
                border: 1px solid #c5cae9;
                color: #1a237e;
                padding: 3px 10px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
            }

            /* Percentage */
            .pct-val        {
                font-size: 15px;
                font-weight: 800;
            }
            .pct-green      {
                color: #2e7d32;
            }
            .pct-orange     {
                color: #e65100;
            }
            .pct-red        {
                color: #c62828;
            }

            /* Progress bar */
            .prog-outer {
                min-width: 130px;
                height: 10px;
                background: #eeeeee;
                border-radius: 10px;
                overflow: hidden;
            }
            .prog-inner      {
                height: 100%;
                border-radius: 10px;
            }
            .prog-green      {
                background: linear-gradient(90deg, #388e3c, #66bb6a);
            }
            .prog-orange     {
                background: linear-gradient(90deg, #ef6c00, #ffa726);
            }
            .prog-red        {
                background: linear-gradient(90deg, #c62828, #ef5350);
            }

            /* Status badges */
            .badge-ok {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 5px 13px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                background: #e8f5e9;
                color: #2e7d32;
                border: 1px solid #a5d6a7;
            }
            .badge-low {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 5px 13px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                background: #ffebee;
                color: #c62828;
                border: 1px solid #ef9a9a;
            }

            /* Table footer bar */
            .table-footer {
                padding: 12px 22px;
                background: #f5f7ff;
                border-top: 1px solid #e8eaf6;
                font-size: 12px;
                color: #777;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            /* ── EMPTY / PLACEHOLDER STATES ─────────────────────────────── */
            .state-box {
                background: #fff;
                border-radius: 14px;
                padding: 60px 20px;
                text-align: center;
                box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            }
            .state-box .s-icon {
                font-size: 56px;
                margin-bottom: 14px;
            }
            .state-box p       {
                font-size: 15px;
                color: #aaa;
                margin: 0;
            }
            .state-box strong  {
                color: #555;
            }

            /* ── RESPONSIVE ─────────────────────────────────────────────── */
            @media (max-width: 800px) {
                .stat-row    {
                    grid-template-columns: 1fr 1fr;
                }
                .filter-grid {
                    grid-template-columns: 1fr;
                }
                .banner-right{
                    display: none;
                }
            }
            @media (max-width: 480px) {
                .stat-row {
                    grid-template-columns: 1fr;
                }
            }

            /*for navbar*/
            /* ── NAVBAR ───────────────────────────────────────────── */

            .navbar {
                background: linear-gradient(135deg, #0d1557 0%, #1a237e 55%, #3949ab 100%);
                color: #ffffff;
                padding: 14px 26px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 4px 14px rgba(13,21,87,0.35);
                border-bottom: 2px solid rgba(255,255,255,0.08);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            /* Title */
            .navbar h2 {
                margin: 0;
                font-size: 20px;
                font-weight: 700;
                letter-spacing: 0.4px;
            }

            /* Links container */
            .nav-links {
                display: flex;
                align-items: center;
                gap: 16px;
            }

            /* Links */
            .nav-links a {
                color: rgba(255,255,255,0.85);
                text-decoration: none;
                font-size: 14px;
                font-weight: 600;
                padding: 7px 14px;
                border-radius: 6px;
                transition: all 0.22s ease;
            }

            /* Hover effect */
            .nav-links a:hover {
                background: rgba(255,255,255,0.14);
                color: #ffffff;
                transform: translateY(-1px);
            }

            /* Active page link (optional class="active") */
            .nav-links a.active {
                background: rgba(255,255,255,0.22);
                color: #ffffff;
            }

            /* Logout button */
            .btn-logout {
                background: linear-gradient(135deg, #c62828, #e53935);
                color: #fff !important;
                padding: 7px 16px !important;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(198,40,40,0.45);
            }

            .btn-logout:hover {
                background: linear-gradient(135deg, #b71c1c, #d32f2f);
                transform: translateY(-1px);
            }

            /* Responsive */
            @media (max-width: 700px) {
                .navbar {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .nav-links {
                    flex-wrap: wrap;
                    gap: 8px;
                }
            }

        </style>
    </head>
    <body>

        <!-- ═══ NAVBAR ════════════════════════════════════════════════════════ -->
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

            <!-- ═══ BANNER ════════════════════════════════════════════════════ -->
            <div class="page-banner">
                <div class="banner-left">
                    <h1>📊 Attendance Report</h1>
                    <p>Select subject &amp; class to generate a detailed attendance percentage report.</p>
                </div>
                <div class="banner-right">📋</div>
            </div>

            <!-- ═══ STAT CARDS — shown only when report has data ═════════════ -->
            <% if (reportData != null && !reportData.isEmpty()) {%>
            <div class="stat-row">
                <div class="stat-card sc-blue">
                    <div class="sc-icon">👥</div>
                    <div>
                        <div class="sc-num"><%= totalStudents%></div>
                        <div class="sc-label">Total Students</div>
                    </div>
                </div>
                <div class="stat-card sc-purple">
                    <div class="sc-icon">📈</div>
                    <div>
                        <div class="sc-num purple"><%= avgPct%>%</div>
                        <div class="sc-label">Class Average</div>
                    </div>
                </div>
                <div class="stat-card sc-green">
                    <div class="sc-icon">✅</div>
                    <div>
                        <div class="sc-num green"><%= okCount%></div>
                        <div class="sc-label">Above 75% (Safe)</div>
                    </div>
                </div>
                <div class="stat-card sc-red">
                    <div class="sc-icon">⚠️</div>
                    <div>
                        <div class="sc-num red"><%= lowCount%></div>
                        <div class="sc-label">Below 75% (At Risk)</div>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- ═══ FILTER FORM ════════════════════════════════════════════════ -->
            <div class="filter-card">
                <div class="filter-card-title">🔍 Generate Report</div>
                <form action="../report" method="get">
                    <div class="filter-grid">
                        <div>
                            <label>Subject</label>
                            <select name="subjectId" required>
                                <option value="">— Select Subject —</option>
                                <% if (subjects != null)
                                for (Subject s : subjects) {%>
                                <option value="<%= s.getSubjectId()%>"
                                        <%= (selSubject != null && selSubject.equals(String.valueOf(s.getSubjectId()))) ? "selected" : ""%>>
                                    <%= s.getSubjectName()%>
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div>
                            <label>Class</label>
                            <select name="classId" required>
                                <option value="">— Select Class —</option>
                                <% if (classes != null)
                                for (ClassRoom c : classes) {%>
                                <option value="<%= c.getClassId()%>"
                                        <%= (selClass != null && selClass.equals(String.valueOf(c.getClassId()))) ? "selected" : ""%>>
                                    <%= c.getClassName()%> — <%= c.getDepartment()%>
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div>
                            <button type="submit" class="btn-generate">⚡ Generate</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- ═══ REPORT TABLE ═══════════════════════════════════════════════ -->
            <% if (reportData != null) { %>

            <% if (!reportData.isEmpty()) {%>
            <div class="report-wrap">

                <div class="report-head">
                    <h3>📄 Student-wise Attendance Summary</h3>
                    <span class="count-pill"><%= reportData.size()%> students</span>
                </div>

                <table class="report-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Roll No</th>
                            <th>Student Name</th>
                            <th>Attendance %</th>
                            <th>Progress</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int no = 1;
                            for (Map<String, String> row : reportData) {
                                double pct = Double.parseDouble(row.get("percentage"));
                                String pctCls = pct >= 75 ? "pct-green" : pct >= 50 ? "pct-orange" : "pct-red";
                                String progCls = pct >= 75 ? "prog-green" : pct >= 50 ? "prog-orange" : "prog-red";
                                double barW = Math.min(pct, 100);
                        %>
                        <tr>
                            <td><span class="sno"><%= no++%></span></td>
                            <td><span class="roll-chip"><%= row.get("rollNo")%></span></td>
                            <td><strong><%= row.get("name")%></strong></td>
                            <td><span class="pct-val <%= pctCls%>"><%= row.get("percentage")%>%</span></td>
                            <td>
                                <div class="prog-outer">
                                    <div class="prog-inner <%= progCls%>" style="width:<%= barW%>%"></div>
                                </div>
                            </td>
                            <td>
                                <% if ("OK".equals(row.get("status"))) { %>
                                <span class="badge-ok">✓ OK</span>
                                <% } else { %>
                                <span class="badge-low">⚠ Low</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <div class="table-footer">
                    <span>⚠ Students below <strong>75%</strong> may be barred from exams.</span>
                    <span>Eligibility Threshold : <strong>75%</strong></span>
                </div>
            </div>

            <% } else { %>
            <div class="state-box">
                <div class="s-icon">🔍</div>
                <p>No students found for the selected <strong>class</strong> and <strong>subject</strong>.</p>
            </div>
            <% } %>

            <% } else { %>
            <div class="state-box">
                <div class="s-icon">📊</div>
                <p>Select a <strong>Subject</strong> and <strong>Class</strong> above, then click <strong>⚡ Generate</strong> to view the report.</p>
            </div>
            <% }%>

        </div>
    </body>
</html>
