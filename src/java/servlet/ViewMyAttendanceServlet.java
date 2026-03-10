package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import dao.*;
import model.*;

public class ViewMyAttendanceServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp?error=unauthorized"); return;
        }
        try {
            int studentId = (int) session.getAttribute("userId");
            AttendanceDAO aDao = new AttendanceDAO();
            SubjectDAO    sDao = new SubjectDAO();

            List<Attendance> allRecords = aDao.getAttendanceByStudentId(studentId);

            // Build subjectId→name map
            Map<Integer, String> subjectNames = new HashMap<>();
            for (Subject s : sDao.getAllSubjects()) {
                subjectNames.put(s.getSubjectId(), s.getSubjectName());
            }

            // Build subject-wise stats: subjectId → [total, present]
            Map<Integer, int[]> stats = new LinkedHashMap<>();
            for (Attendance a : allRecords) {
                int[] arr = stats.getOrDefault(a.getSubjectId(), new int[]{0, 0});
                arr[0]++;
                if ("Present".equals(a.getStatus())) arr[1]++;
                stats.put(a.getSubjectId(), arr);
            }

            List<Map<String, String>> summary = new ArrayList<>();
            for (Map.Entry<Integer, int[]> e : stats.entrySet()) {
                int    sid     = e.getKey();
                int    total   = e.getValue()[0];
                int    present = e.getValue()[1];
                double pct     = total > 0 ? (present * 100.0) / total : 0;
                Map<String, String> row = new HashMap<>();
                row.put("subjectId",   String.valueOf(sid));
                row.put("subjectName", subjectNames.getOrDefault(sid, "Subject " + sid));
                row.put("total",       String.valueOf(total));
                row.put("present",     String.valueOf(present));
                row.put("absent",      String.valueOf(total - present));
                row.put("percentage",  String.format("%.1f", pct));
                row.put("status",      pct < 75 ? "Low" : "OK");
                summary.add(row);
            }

            request.setAttribute("subjectSummary", summary);
            request.setAttribute("subjectNames",   subjectNames);

            // Optional drill-down by specific subject
            String filterSid = request.getParameter("subjectId");
            if (filterSid != null && !filterSid.isEmpty()) {
                int fid = Integer.parseInt(filterSid);
                List<Attendance> filtered = new ArrayList<>();
                for (Attendance a : allRecords) {
                    if (a.getSubjectId() == fid) filtered.add(a);
                }
                request.setAttribute("filteredRecords",   filtered);
                request.setAttribute("selectedSubjectId", filterSid);
            }

            request.getRequestDispatcher("/student/viewMyAttendance.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
