package dao;

import model.Subject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    private Subject mapRow(ResultSet rs) throws SQLException {
        Subject s = new Subject();
        s.setSubjectId  (rs.getInt   ("subject_id"));
        s.setSubjectName(rs.getString("subject_name"));
        s.setDepartment (rs.getString("department"));
        s.setSemester   (rs.getInt   ("semester"));
        s.setTeacherId  (rs.getInt   ("teacher_id"));
        return s;
    }

    public boolean addSubject(Subject s) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO subject (subject_name, department, semester, teacher_id) VALUES (?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getSubjectName());
            ps.setString(2, s.getDepartment());
            ps.setInt   (3, s.getSemester());
            ps.setInt   (4, s.getTeacherId());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Subject> getAllSubjects() throws SQLException, ClassNotFoundException {
        List<Subject> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery("SELECT * FROM subject ORDER BY subject_id")) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public Subject getSubjectById(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM subject WHERE subject_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    public List<Subject> getSubjectsByTeacherId(int teacherId) throws SQLException, ClassNotFoundException {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject WHERE teacher_id=? ORDER BY subject_id";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public boolean updateSubject(Subject s) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE subject SET subject_name=?, department=?, semester=?, teacher_id=? WHERE subject_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getSubjectName());
            ps.setString(2, s.getDepartment());
            ps.setInt   (3, s.getSemester());
            ps.setInt   (4, s.getTeacherId());
            ps.setInt   (5, s.getSubjectId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteSubject(int id) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM subject WHERE subject_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
