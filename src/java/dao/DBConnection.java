package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Provides a static helper method to get a MySQL JDBC connection.
 * Update URL, USER, PASSWORD to match your local MySQL setup.
 */
public class DBConnection {

    private static final String URL      = "jdbc:mysql://localhost:3306/attendance_system?useSSL=false&serverTimezone=UTC";
    private static final String USER     = "root";
    private static final String PASSWORD = "Jash@1405"; // <-- Change this

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
