<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    if (session.getAttribute("role") != null) {
        String r = (String)session.getAttribute("role");
        if      ("admin"  .equals(r)) { response.sendRedirect("admin/dashboard");   return; }
        else if ("teacher".equals(r)) { response.sendRedirect("teacher/dashboard"); return; }
        else if ("student".equals(r)) { response.sendRedirect("student/dashboard"); return; }
    }
    String error          = (String)request.getAttribute("error");
    String message        = request.getParameter("message");
    String errorParam     = request.getParameter("error");
    String enteredUser    = (String)request.getAttribute("enteredUsername");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login — OAMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body{background:linear-gradient(135deg,#0d1557,#283593);min-height:100vh;display:flex;align-items:center;justify-content:center;}
        .login-wrap{display:flex;background:white;border-radius:14px;overflow:hidden;max-width:840px;width:100%;box-shadow:0 20px 60px rgba(0,0,0,0.35);}
        .login-left{background:linear-gradient(180deg,#1a237e,#0d1557);color:white;padding:50px 36px;width:38%;display:flex;flex-direction:column;justify-content:center;align-items:center;text-align:center;}
        .login-left .icon{font-size:58px;margin-bottom:14px;}
        .login-left h2{font-size:21px;margin-bottom:8px;}
        .login-left p{font-size:13px;opacity:0.8;line-height:1.5;}
        .roles{margin-top:22px;text-align:left;}
        .roles div{padding:7px 0;font-size:14px;opacity:0.85;}
        .roles span{margin-right:7px;}
        .login-right{padding:46px 42px;width:62%;}
        .login-right h1{font-size:25px;color:#1a237e;margin-bottom:4px;}
        .login-right .sub{color:#888;font-size:13px;margin-bottom:26px;}
        .a-login{padding:13px 16px;border:2px solid #e0e0e0;border-radius:7px;font-size:15px;width:100%;transition:border 0.25s;}
        .a-login:focus{border-color:#1a237e;outline:none;box-shadow:0 0 0 3px rgba(26,35,126,0.1);}
        .login-btn{width:100%;padding:13px;background:#1a237e;color:white;border:none;border-radius:7px;font-size:15px;font-weight:700;cursor:pointer;transition:background 0.25s;}
        .login-btn:hover{background:#0d1557;}
        .alert-login{padding:11px 15px;border-radius:7px;margin-bottom:17px;font-size:14px;}
        .alert-login.err  {background:#ffebee;color:#c62828;border:1px solid #ef9a9a;}
        .alert-login.succ {background:#e8f5e9;color:#2e7d32;border:1px solid #a5d6a7;}
        .alert-login.warn {background:#fff8e1;color:#e65100;border:1px solid #ffe082;}
        .back-link{display:block;text-align:center;margin-top:18px;color:#888;font-size:13px;text-decoration:none;}
        .back-link:hover{color:#1a237e;}
        @media(max-width:680px){.login-wrap{flex-direction:column;}.login-left,.login-right{width:100%;padding:28px;}}
    </style>
</head>
<body>
<div class="login-wrap">
    <div class="login-left">
        <div class="icon">🎓</div>
        <h2>OAMS</h2>
        <p>Online Attendance Management System</p>
        <div class="roles">
            <div><span>👨‍💼</span> Admin — Manage system</div>
            <div><span>👩‍🏫</span> Teacher — Mark attendance</div>
            <div><span>👨‍🎓</span> Student — View attendance</div>
        </div>
    </div>
    <div class="login-right">
        <h1>Welcome Back</h1>
        <p class="sub">Sign in to your account to continue</p>

        <% if (error != null) { %><div class="alert-login err"><strong>⚠</strong> <%= error %></div><% } %>
        <% if ("loggedout"    .equals(message))    { %><div class="alert-login succ">✓ You have been logged out successfully.</div><% } %>
        <% if ("unauthorized" .equals(errorParam)) { %><div class="alert-login warn">🔒 Please login to access that page.</div><% } %>
        <% if ("sessionexpired".equals(errorParam)){ %><div class="alert-login warn">⏰ Your session has expired. Please login again.</div><% } %>

        <form action="login" method="post" autocomplete="off">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="a-login" required autofocus
                       placeholder="Enter your username"
                       value="<%= enteredUser != null ? enteredUser : "" %>">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="a-login" required
                       placeholder="Enter your password">
            </div>
            
            <button type="submit" class="login-btn">Sign In →</button>
        </form>
        <a href="index.jsp" class="back-link">← Back to Home</a>
    </div>
</div>
<script>
    if (window.history.replaceState) window.history.replaceState(null, null, window.location.href);
    window.onpopstate = function(){ window.history.go(1); };
</script>
</body>
</html>
