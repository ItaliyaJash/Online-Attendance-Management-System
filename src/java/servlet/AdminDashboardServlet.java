package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.*;

public class AdminDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }

        try {
            request.setAttribute("totalStudents", new StudentDAO().getAllStudents().size());
            request.setAttribute("totalTeachers", new TeacherDAO().getAllTeachers().size());
            request.setAttribute("totalClasses",  new ClassDAO().getAllClasses().size());
            request.setAttribute("totalSubjects", new SubjectDAO().getAllSubjects().size());
            request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
