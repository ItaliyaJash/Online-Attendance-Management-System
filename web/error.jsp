<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
    <title>Error — OAMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body{background:#f0f2f5;display:flex;align-items:center;justify-content:center;min-height:100vh;}
        .err-card{background:white;border-radius:14px;box-shadow:0 8px 30px rgba(0,0,0,0.1);padding:48px 56px;text-align:center;max-width:480px;width:100%;}
        .err-icon{font-size:64px;margin-bottom:14px;}
        .err-card h1{font-size:26px;color:#c62828;margin-bottom:10px;}
        .err-card p {font-size:15px;color:#666;line-height:1.6;margin-bottom:24px;}
        .err-actions{display:flex;gap:12px;justify-content:center;}
        .e-btn{padding:11px 22px;border-radius:7px;text-decoration:none;font-weight:600;font-size:14px;}
        .btn-home {background:#1a237e;color:white;}
        .btn-back {background:#e0e0e0;color:#333;}
        .btn-login{background:#2e7d32;color:white;}
    </style>
</head>
<body>
<div class="err-card">
    <div class="err-icon">⚠️</div>
    <h1>Something Went Wrong</h1>
    <p>An unexpected error occurred. Please try again or return to the home page.</p>
    <div class="err-actions">
        <a href="index.jsp"              class="e-btn btn-home" >🏠 Home</a>
        <a href="javascript:history.back()" class="e-btn btn-back">← Back</a>
        <a href="login.jsp"              class="e-btn btn-login">🔐 Login</a>
    </div>
</div>
</body>
</html>
