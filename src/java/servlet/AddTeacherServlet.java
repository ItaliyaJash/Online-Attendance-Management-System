package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.TeacherDAO;
import model.Teacher;

public class AddTeacherServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        request.getRequestDispatcher("/admin/addTeacher.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        Teacher t = new Teacher();
        t.setName      (request.getParameter("name"));
        t.setEmail     (request.getParameter("email"));
        t.setPhone     (request.getParameter("phone"));
        t.setDepartment(request.getParameter("department"));
        t.setUsername  (request.getParameter("username"));
        t.setPassword  (request.getParameter("password"));
        try {
            if (new TeacherDAO().addTeacher(t)) {
                response.sendRedirect("viewTeachers?success=added");
            } else {
                request.setAttribute("error", "Failed to add teacher.");
                request.getRequestDispatcher("/admin/addTeacher.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            try { request.getRequestDispatcher("/admin/addTeacher.jsp").forward(request, response); }
            catch (Exception ex) { response.sendRedirect("../error.jsp"); }
        }
    }
}
