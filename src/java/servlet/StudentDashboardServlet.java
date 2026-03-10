package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import dao.*;
import model.*;

public class StudentDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            int studentId = (int) session.getAttribute("userId");
            Student student = new StudentDAO().getStudentById(studentId);
            request.setAttribute("student", student);

            List<Attendance> all = new AttendanceDAO().getAttendanceByStudentId(studentId);
            int total   = all.size();
            int present = (int) all.stream().filter(a -> "Present".equals(a.getStatus())).count();
            double pct  = total > 0 ? (present * 100.0) / total : 0;

            request.setAttribute("totalClasses",      total);
            request.setAttribute("presentCount",      present);
            request.setAttribute("absentCount",       total - present);
            request.setAttribute("overallPercentage", String.format("%.1f", pct));

            request.getRequestDispatcher("/student/studentDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
