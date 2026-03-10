package dao;

import model.ClassRoom;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClassDAO {

    private ClassRoom mapRow(ResultSet rs) throws SQLException {
        ClassRoom c = new ClassRoom();
        c.setClassId   (rs.getInt   ("class_id"));
        c.setClassName (rs.getString("class_name"));
        c.setDepartment(rs.getString("department"));
        c.setSemester  (rs.getInt   ("semester"));
        return c;
    }

    public boolean addClass(ClassRoom c) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO class (class_name, department, semester) VALUES (?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getClassName());
            ps.setString(2, c.getDepartment());
            ps.setInt   (3, c.getSemester());
            return ps.executeUpdate() > 0;
        }
    }

    public List<ClassRoom> getAllClasses() throws SQLException, ClassNotFoundException {
        List<ClassRoom> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery("SELECT * FROM class ORDER BY class_id")) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public ClassRoom getClassById(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM class WHERE class_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    public boolean updateClass(ClassRoom c) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE class SET class_name=?, department=?, semester=? WHERE class_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getClassName());
            ps.setString(2, c.getDepartment());
            ps.setInt   (3, c.getSemester());
            ps.setInt   (4, c.getClassId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteClass(int id) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM class WHERE class_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
