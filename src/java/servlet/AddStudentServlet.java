package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.StudentDAO;
import dao.ClassDAO;
import model.Student;

public class AddStudentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            request.setAttribute("classes", new ClassDAO().getAllClasses());
            request.getRequestDispatcher("/admin/addStudent.jsp").forward(request, response);
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
        Student s = new Student();
        s.setRollNo    (request.getParameter("rollNo"));
        s.setName      (request.getParameter("name"));
        s.setEmail     (request.getParameter("email"));
        s.setDepartment(request.getParameter("department"));
        s.setSemester  (Integer.parseInt(request.getParameter("semester")));
        s.setClassId   (Integer.parseInt(request.getParameter("classId")));
        s.setUsername  (request.getParameter("username"));
        s.setPassword  (request.getParameter("password"));
        try {
            if (new StudentDAO().addStudent(s)) {
                response.sendRedirect("viewStudents?success=added");
            } else {
                request.setAttribute("error", "Failed to add student.");
                request.setAttribute("classes", new ClassDAO().getAllClasses());
                request.getRequestDispatcher("/admin/addStudent.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
