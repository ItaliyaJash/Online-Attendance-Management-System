package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import dao.SubjectDAO;
import model.Subject;

public class TeacherDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            int teacherId = (int) session.getAttribute("userId");
            List<Subject> subjects = new SubjectDAO().getSubjectsByTeacherId(teacherId);
            request.setAttribute("subjects", subjects);
            request.getRequestDispatcher("/teacher/teacherDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
