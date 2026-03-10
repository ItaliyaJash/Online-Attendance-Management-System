package dao;

import model.User;
import java.sql.*;

public class UserDAO {

    /**
     * Checks admin, teacher, and student tables in order.
     * Returns a User object with role set, or null if credentials invalid.
     */
    public User login(String username, String password)
            throws SQLException, ClassNotFoundException {

        Connection con = DBConnection.getConnection();

        // 1. Check admin table
        String sql = "SELECT admin_id, username, password FROM admin WHERE username=? AND password=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("admin_id"),
                                rs.getString("username"),
                                rs.getString("password"),
                                "admin");
            }
        }

        // 2. Check teacher table
        sql = "SELECT teacher_id, username, password FROM teacher WHERE username=? AND password=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("teacher_id"),
                                rs.getString("username"),
                                rs.getString("password"),
                                "teacher");
            }
        }

        // 3. Check student table
        sql = "SELECT student_id, username, password FROM student WHERE username=? AND password=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("student_id"),
                                rs.getString("username"),
                                rs.getString("password"),
                                "student");
            }
        }

        con.close();
        return null; // Invalid credentials
    }
}
