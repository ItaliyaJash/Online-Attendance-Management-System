package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.*;
import model.*;

public class StudentProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            int     studentId = (int) session.getAttribute("userId");
            Student student   = new StudentDAO().getStudentById(studentId);
            request.setAttribute("student", student);
            if (student != null) {
                request.setAttribute("classRoom", new ClassDAO().getClassById(student.getClassId()));
            }
            request.getRequestDispatcher("/student/studentProfile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
