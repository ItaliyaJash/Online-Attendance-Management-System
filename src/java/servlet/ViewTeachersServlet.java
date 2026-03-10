package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.TeacherDAO;

public class ViewTeachersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            request.setAttribute("teachers", new TeacherDAO().getAllTeachers());
            request.getRequestDispatcher("/admin/viewTeachers.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
