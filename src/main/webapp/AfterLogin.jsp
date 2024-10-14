<%@ page import="java.sql.*" %>


<%
    String teacherName = request.getParameter("teacherName");
    String password = request.getParameter("password");

    // Initialize database variables
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String jdbcUrl = "jdbc:mysql://localhost:3306/final";  // Replace with your DB URL
    String dbUser = "root";  // Replace with your DB username
    String dbPassword = "Parth@007";  // Replace with your DB password

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish the connection
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        // Prepare the SQL query to check username and password
        String sql = "SELECT * FROM teacherLogin WHERE username = ? AND password = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, teacherName);
        ps.setString(2, password);

        // Execute the query
        rs = ps.executeQuery();

        // Check if the result set contains a matching user
        if (rs.next()) {
            // If a match is found, redirect to Home.jsp
            HttpSession s = request.getSession(); // Create a session if it doesn't exist
            s.setAttribute("teacherId", rs.getInt("id")); // Use "id" to get the teacher's ID

            response.sendRedirect("Home.jsp");
        } else {
            // If no match, show an error message
            out.println("<p style='color:red;'>Invalid username or password</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red;'>An error occurred while processing your request.</p>");
    } finally {
        // Close all resources
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
