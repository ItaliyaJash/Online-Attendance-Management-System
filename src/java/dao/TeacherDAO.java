package dao;

import model.Teacher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeacherDAO {

    private Teacher mapRow(ResultSet rs) throws SQLException {
        Teacher t = new Teacher();
        t.setTeacherId (rs.getInt   ("teacher_id"));
        t.setName      (rs.getString("name"));
        t.setEmail     (rs.getString("email"));
        t.setPhone     (rs.getString("phone"));
        t.setDepartment(rs.getString("department"));
        t.setUsername  (rs.getString("username"));
        t.setPassword  (rs.getString("password"));
        return t;
    }

    public boolean addTeacher(Teacher t) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO teacher (name, email, phone, department, username, password) VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getEmail());
            ps.setString(3, t.getPhone());
            ps.setString(4, t.getDepartment());
            ps.setString(5, t.getUsername());
            ps.setString(6, t.getPassword());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Teacher> getAllTeachers() throws SQLException, ClassNotFoundException {
        List<Teacher> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery("SELECT * FROM teacher ORDER BY teacher_id")) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public Teacher getTeacherById(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM teacher WHERE teacher_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    public boolean updateTeacher(Teacher t) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE teacher SET name=?, email=?, phone=?, department=? WHERE teacher_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getEmail());
            ps.setString(3, t.getPhone());
            ps.setString(4, t.getDepartment());
            ps.setInt   (5, t.getTeacherId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteTeacher(int id) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM teacher WHERE teacher_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
