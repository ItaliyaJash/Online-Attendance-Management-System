package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.SubjectDAO;
import dao.TeacherDAO;
import model.Subject;

public class AddSubjectServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            request.setAttribute("teachers", new TeacherDAO().getAllTeachers());
            request.getRequestDispatcher("/admin/addSubject.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        Subject s = new Subject();
        s.setSubjectName(request.getParameter("subjectName"));
        s.setDepartment (request.getParameter("department"));
        s.setSemester   (Integer.parseInt(request.getParameter("semester")));
        s.setTeacherId  (Integer.parseInt(request.getParameter("teacherId")));
        try {
            if (new SubjectDAO().addSubject(s)) {
                response.sendRedirect("dashboard?success=subjectAdded");
            } else {
                request.setAttribute("error", "Failed to add subject.");
                request.setAttribute("teachers", new TeacherDAO().getAllTeachers());
                request.getRequestDispatcher("/admin/addSubject.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
