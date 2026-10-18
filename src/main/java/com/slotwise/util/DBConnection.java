package com.slotwise.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * DBConnection Utility Class
 * ============================
 * Provides reusable database connection management for JDBC.
 *
 * JDBC CONNECTIVITY:
 * - Loads MySQL driver.
 * - Reads connection settings from application.properties file.
 * - Provides a static method to obtain a Connection object.
 * - Uses try-with-resources pattern in calling code.
 *
 * SECURITY:
 * - Database credentials are stored in a properties file outside
 *   version control (listed in .gitignore).
 * - Credentials are never exposed in JSP pages or browser output.
 */
public class DBConnection {

    private static String URL;
    private static String USERNAME;
    private static String PASSWORD;

    // Static initializer — loads configuration once when the class is first used
    static {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Load database properties from the classpath
            Properties props = new Properties();
            InputStream input = DBConnection.class.getClassLoader()
                    .getResourceAsStream("application.properties");

            if (input != null) {
                props.load(input);
                URL = props.getProperty("db.url");
                USERNAME = props.getProperty("db.username");
                PASSWORD = props.getProperty("db.password");
                input.close();
            } else {
                // Fallback defaults for local development
                System.err.println("[SlotWise] WARNING: application.properties not found. "
                        + "Using fallback defaults. Create src/main/resources/application.properties "
                        + "from the .example file.");
                URL = "jdbc:mysql://localhost:3306/slotwise_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata";
                USERNAME = "root";
                PASSWORD = "";
            }
        } catch (Exception e) {
            System.err.println("[SlotWise] ERROR: Failed to initialize database configuration.");
            e.printStackTrace();
        }
    }

    /**
     * Returns a new database connection.
     * Callers should use try-with-resources to ensure the connection is closed.
     *
     * Example usage:
     *   try (Connection conn = DBConnection.getConnection()) {
     *       // Use connection
     *   }
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * Safely closes a connection (null-safe).
     */
    public static void closeQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                // Suppress close errors
            }
        }
    }
}
