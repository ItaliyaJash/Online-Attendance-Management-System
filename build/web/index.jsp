<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("role") != null) {
        String role = (String) session.getAttribute("role");
        if      ("admin"  .equals(role)) { response.sendRedirect("admin/dashboard");   return; }
        else if ("teacher".equals(role)) { response.sendRedirect("teacher/dashboard"); return; }
        else if ("student".equals(role)) { response.sendRedirect("student/dashboard"); return; }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Online Attendance Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hero {
            min-height: 100vh;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            background: linear-gradient(135deg, #0d1557 0%, #1a237e 40%, #283593 100%);
            color: white; text-align: center; padding: 40px 20px;
        }
        .hero-icon { font-size: 80px; margin-bottom: 18px; }
        .hero h1   { font-size: 40px; margin-bottom: 10px; letter-spacing:-0.5px; }
        .hero p    { font-size: 18px; opacity:0.85; max-width:560px; line-height:1.6; margin-bottom:32px; }
        .hero-btn  {
            display:inline-block; background:white; color:#1a237e;
            padding:14px 42px; border-radius:8px; text-decoration:none;
            font-size:17px; font-weight:700;
            box-shadow:0 4px 15px rgba(0,0,0,0.25);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .hero-btn:hover { transform:translateY(-2px); box-shadow:0 6px 25px rgba(0,0,0,0.3); }
        .features {
            display:grid; grid-template-columns:repeat(3,1fr);
            gap:22px; max-width:900px; margin-top:48px;
        }
        .feature-card {
            background:rgba(255,255,255,0.1);
            border:1px solid rgba(255,255,255,0.15);
            border-radius:12px; padding:24px;
        }
        .feature-card .feat-icon { font-size:30px; margin-bottom:10px; }
        .feature-card h3 { font-size:16px; margin-bottom:6px; }
        .feature-card p  { font-size:13px; opacity:0.75; margin:0; }
        .footer { margin-top:48px; opacity:0.45; font-size:13px; }
        @media(max-width:700px){
            .hero h1{font-size:26px;} .features{grid-template-columns:1fr; max-width:340px;}
        }
    </style>
</head>
<body>
<div class="hero">
    <div class="hero-icon">🎓</div>
    <h1>Online Attendance<br>Management System</h1>
    <p>A digital platform for managing, tracking and reporting student attendance efficiently across all departments.</p>
    <a href="login.jsp" class="hero-btn">Login to Continue →</a>
    <div class="features">
        <div class="feature-card">
            <div class="feat-icon">👨‍💼</div>
            <h3>Admin Panel</h3>
            <p>Manage teachers, students, classes &amp; subjects. Full system control.</p>
        </div>
        <div class="feature-card">
            <div class="feat-icon">👩‍🏫</div>
            <h3>Teacher Panel</h3>
            <p>Mark attendance, view records, update entries &amp; generate reports.</p>
        </div>
        <div class="feature-card">
            <div class="feat-icon">👨‍🎓</div>
            <h3>Student Panel</h3>
            <p>View your attendance percentage, day-wise records &amp; profile.</p>
        </div>
    </div>
    <div class="footer">© 2026 Online Attendance Management System | Java Servlet + JSP + MySQL</div>
</div>
</body>
</html>
