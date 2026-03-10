package dao;

import model.Attendance;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    private Attendance mapRow(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();
        a.setAttendanceId(rs.getInt   ("attendance_id"));
        a.setStudentId   (rs.getInt   ("student_id"));
        a.setSubjectId   (rs.getInt   ("subject_id"));
        a.setTeacherId   (rs.getInt   ("teacher_id"));
        a.setDate        (rs.getString("date"));
        a.setStatus      (rs.getString("status"));
        return a;
    }

    // Mark attendance for one student
    public boolean markAttendance(Attendance a) throws SQLException, ClassNotFoundException {
        // Use INSERT ... ON DUPLICATE KEY UPDATE to avoid duplicate errors
        String sql = "INSERT INTO attendance (student_id, subject_id, teacher_id, date, status) "
                   + "VALUES (?,?,?,?,?) "
                   + "ON DUPLICATE KEY UPDATE status=VALUES(status)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt   (1, a.getStudentId());
            ps.setInt   (2, a.getSubjectId());
            ps.setInt   (3, a.getTeacherId());
            ps.setString(4, a.getDate());
            ps.setString(5, a.getStatus());
            return ps.executeUpdate() > 0;
        }
    }

    // Get all attendance records for a student
    public List<Attendance> getAttendanceByStudentId(int studentId) throws SQLException, ClassNotFoundException {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance WHERE student_id=? ORDER BY date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // Get attendance records for a subject on a specific date
    public List<Attendance> getAttendanceBySubjectAndDate(int subjectId, String date)
            throws SQLException, ClassNotFoundException {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance WHERE subject_id=? AND date=? ORDER BY student_id";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt   (1, subjectId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // Get attendance for a student in a subject (for percentage)
    public List<Attendance> getAttendanceByStudentAndSubject(int studentId, int subjectId)
            throws SQLException, ClassNotFoundException {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance WHERE student_id=? AND subject_id=? ORDER BY date";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // Update a single attendance record status
    public boolean updateAttendance(int attendanceId, String status)
            throws SQLException, ClassNotFoundException {
        String sql = "UPDATE attendance SET status=? WHERE attendance_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, attendanceId);
            return ps.executeUpdate() > 0;
        }
    }

    // Delete an attendance record
    public boolean deleteAttendance(int attendanceId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM attendance WHERE attendance_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, attendanceId);
            return ps.executeUpdate() > 0;
        }
    }

    // Calculate attendance percentage for a student in a subject
    public double getAttendancePercentage(int studentId, int subjectId)
            throws SQLException, ClassNotFoundException {
        String sql = "SELECT "
                   + "COUNT(*) AS total, "
                   + "SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) AS present "
                   + "FROM attendance WHERE student_id=? AND subject_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int total   = rs.getInt("total");
                int present = rs.getInt("present");
                return total == 0 ? 0.0 : (present * 100.0) / total;
            }
        }
        return 0.0;
    }
}
