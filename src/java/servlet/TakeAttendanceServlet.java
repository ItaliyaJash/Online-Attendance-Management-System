package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import dao.*;
import model.*;

public class TakeAttendanceServlet extends HttpServlet {

    // GET — Show subject/class/date selector, then student list
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            int teacherId = (int) session.getAttribute("userId");
            request.setAttribute("subjects", new SubjectDAO().getSubjectsByTeacherId(teacherId));
            request.setAttribute("classes",  new ClassDAO().getAllClasses());

            String subjectId = request.getParameter("subjectId");
            String classId   = request.getParameter("classId");
            String date      = request.getParameter("date");

            if (subjectId != null && classId != null && date != null && !date.isEmpty()) {
                List<Student> students = new StudentDAO().getStudentsByClassId(Integer.parseInt(classId));
                request.setAttribute("students",          students);
                request.setAttribute("selectedSubjectId", subjectId);
                request.setAttribute("selectedClassId",   classId);
                request.setAttribute("selectedDate",      date);
            }
            request.getRequestDispatcher("/teacher/takeAttendance.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }

    // POST — Save attendance records submitted via form
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            int    teacherId = (int) session.getAttribute("userId");
            int    subjectId = Integer.parseInt(request.getParameter("subjectId"));
            String date      = request.getParameter("date");
            String[] sids    = request.getParameterValues("studentId");

            if (sids != null) {
                AttendanceDAO dao = new AttendanceDAO();
                for (String sid : sids) {
                    int    studentId = Integer.parseInt(sid);
                    String status    = request.getParameter("status_" + studentId);
                    Attendance a = new Attendance();
                    a.setStudentId(studentId);
                    a.setSubjectId(subjectId);
                    a.setTeacherId(teacherId);
                    a.setDate(date);
                    a.setStatus(status != null ? status : "Absent");
                    dao.markAttendance(a);
                }
            }
            response.sendRedirect("viewAttendance?subjectId=" + subjectId + "&date=" + date + "&success=marked");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
