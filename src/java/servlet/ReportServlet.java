package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import dao.*;
import model.*;

public class ReportServlet extends HttpServlet {

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

            if (subjectId != null && classId != null) {
                int sid = Integer.parseInt(subjectId);
                int cid = Integer.parseInt(classId);

                List<Student>           students   = new StudentDAO().getStudentsByClassId(cid);
                AttendanceDAO           aDao       = new AttendanceDAO();
                List<Map<String,String>> reportData = new ArrayList<>();

                for (Student s : students) {
                    double pct = aDao.getAttendancePercentage(s.getStudentId(), sid);
                    Map<String,String> row = new HashMap<>();
                    row.put("rollNo",     s.getRollNo());
                    row.put("name",       s.getName());
                    row.put("percentage", String.format("%.1f", pct));
                    row.put("status",     pct < 75 ? "Low" : "OK");
                    reportData.add(row);
                }
                request.setAttribute("reportData",        reportData);
                request.setAttribute("selectedSubjectId", subjectId);
                request.setAttribute("selectedClassId",   classId);
            }
            request.getRequestDispatcher("/teacher/teacherReport.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
