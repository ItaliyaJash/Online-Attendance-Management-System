package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.UserDAO;
import model.User;

public class LoginServlet extends HttpServlet {

    // GET — if already logged in, redirect; otherwise show login page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("role") != null) {
            redirectByRole((String) session.getAttribute("role"), response);
            return;
        }   
        response.sendRedirect("login.jsp");
    }

    // POST — process login form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Basic empty-field validation
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO dao  = new UserDAO();
            User    user = dao.login(username.trim(), password.trim());

            if (user != null) {
                // Create a new session and store user info
                HttpSession session = request.getSession(true);
                session.setAttribute("userId",   user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role",     user.getRole());
                session.setMaxInactiveInterval(60 * 60); // 60-minute timeout

                redirectByRole(user.getRole(), response);
            } else {
                request.setAttribute("error", "Invalid username or password. Please try again.");
                request.setAttribute("enteredUsername", username);
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error. Please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void redirectByRole(String role, HttpServletResponse response) throws IOException {
        switch (role) {
            case "admin":   response.sendRedirect("admin/dashboard");   break;
            case "teacher": response.sendRedirect("teacher/dashboard"); break;
            case "student": response.sendRedirect("student/dashboard"); break;
            default:        response.sendRedirect("login.jsp?error=invalidrole");
        }
    }
}
