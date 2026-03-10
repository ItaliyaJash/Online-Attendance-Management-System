package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.AttendanceDAO;

public class UpdateAttendanceServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            int    attendanceId = Integer.parseInt(request.getParameter("attendanceId"));
            String status       = request.getParameter("status");
            String subjectId    = request.getParameter("subjectId");
            String date         = request.getParameter("date");

            new AttendanceDAO().updateAttendance(attendanceId, status);
            response.sendRedirect("viewAttendance?subjectId=" + subjectId + "&date=" + date + "&success=updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
