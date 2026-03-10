package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.ClassDAO;
import model.ClassRoom;

public class AddClassServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        request.getRequestDispatcher("/admin/addClass.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        ClassRoom c = new ClassRoom();
        c.setClassName (request.getParameter("className"));
        c.setDepartment(request.getParameter("department"));
        c.setSemester  (Integer.parseInt(request.getParameter("semester")));
        try {
            if (new ClassDAO().addClass(c)) {
                response.sendRedirect("dashboard?success=classAdded");
            } else {
                request.setAttribute("error", "Failed to add class.");
                request.getRequestDispatcher("/admin/addClass.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
