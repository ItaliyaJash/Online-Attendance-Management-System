package dao;

import model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // Helper: map current ResultSet row to a Student object
    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        s.setRollNo(rs.getString("roll_no"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setDepartment(rs.getString("department"));
        s.setSemester(rs.getInt("semester"));
        s.setClassId(rs.getInt("class_id"));
        s.setUsername(rs.getString("username"));
        s.setPassword(rs.getString("password"));
        return s;
    }

    // CREATE
    public boolean addStudent(Student s) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO student (roll_no, name, email, department, semester, class_id, username, password) "
                   + "VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getRollNo());
            ps.setString(2, s.getName());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getDepartment());
            ps.setInt   (5, s.getSemester());
            ps.setInt   (6, s.getClassId());
            ps.setString(7, s.getUsername());
            ps.setString(8, s.getPassword());
            return ps.executeUpdate() > 0;
        }
    }

    // READ ALL
    public List<Student> getAllStudents() throws SQLException, ClassNotFoundException {
        List<Student> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery("SELECT * FROM student ORDER BY student_id")) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // READ BY ID
    public Student getStudentById(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM student WHERE student_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    // READ BY CLASS ID
    public List<Student> getStudentsByClassId(int classId) throws SQLException, ClassNotFoundException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student WHERE class_id=? ORDER BY roll_no";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // UPDATE
    public boolean updateStudent(Student s) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE student SET roll_no=?, name=?, email=?, department=?, semester=?, class_id=? "
                   + "WHERE student_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getRollNo());
            ps.setString(2, s.getName());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getDepartment());
            ps.setInt   (5, s.getSemester());
            ps.setInt   (6, s.getClassId());
            ps.setInt   (7, s.getStudentId());
            return ps.executeUpdate() > 0;
        }
    }

    // DELETE
    public boolean deleteStudent(int id) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM student WHERE student_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
