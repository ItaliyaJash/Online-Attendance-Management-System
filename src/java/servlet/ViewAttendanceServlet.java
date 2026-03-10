package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import dao.*;
import model.*;

public class ViewAttendanceServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            int teacherId = (int) session.getAttribute("userId");
            request.setAttribute("subjects", new SubjectDAO().getSubjectsByTeacherId(teacherId));

            String subjectId = request.getParameter("subjectId");
            String date      = request.getParameter("date");

            if (subjectId != null && date != null && !date.isEmpty()) {
                List<Attendance> records = new AttendanceDAO()
                        .getAttendanceBySubjectAndDate(Integer.parseInt(subjectId), date);

                Map<Integer, String> names = new HashMap<>();
                Map<Integer, String> rolls = new HashMap<>();
                StudentDAO sDao = new StudentDAO();
                for (Attendance a : records) {
                    if (!names.containsKey(a.getStudentId())) {
                        Student s = sDao.getStudentById(a.getStudentId());
                        if (s != null) {
                            names.put(a.getStudentId(), s.getName());
                            rolls.put(a.getStudentId(), s.getRollNo());
                        }
                    }
                }
                request.setAttribute("records",           records);
                request.setAttribute("studentNames",      names);
                request.setAttribute("studentRolls",      rolls);
                request.setAttribute("selectedSubjectId", subjectId);
                request.setAttribute("selectedDate",      date);
            }
            request.getRequestDispatcher("/teacher/viewAttendance.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
