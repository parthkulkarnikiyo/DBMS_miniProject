<%@ page import="java.sql.*, java.io.*" %>
<%
    // Get the student ID and password from request parameters
    String studentId = request.getParameter("studentId");
    String password = request.getParameter("password");

    String jdbcUrl = "jdbc:mysql://localhost:3306/final";  // Update with your DB
    String dbUser = "root";  // Update with your DB user
    String dbPassword = "Parth@007";  // Update with your DB password

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        // Validate student login
        String sql = "SELECT total_attended FROM students WHERE studentId = ? AND password = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(studentId)); // Assuming studentId is of INT type
        ps.setString(2, password);
        rs = ps.executeQuery();

        if (rs.next()) {
            int totalAttended = rs.getInt("total_attended");
            int totalLectures = 30; // Update this based on your actual total lectures

            // Calculate attendance percentage
            double attendancePercentage = ((double) totalAttended / totalLectures) * 1000;

            // Display attendance information
            out.println("<!DOCTYPE html>");
            out.println("<html lang='en'>");
            out.println("<head>");
            out.println("<meta charset='UTF-8'>");
            out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
            out.println("<title>Student Attendance</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; background-color: #f4f4f4; }");
            out.println(".container { max-width: 600px; margin: 40px auto; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
            out.println("h2 { color: #4caf50; text-align: center; }");
            out.println("p { text-align: center; font-size: 18px; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<div class='container'>");
            out.println("<h2>Attendance Details</h2>");
            out.println("<p>Attendance Percentage: " + String.format("%.2f", attendancePercentage) + "%</p>"); // Display percentage
            out.println("</div>");
            out.println("</body>");
            out.println("</html>");
        } else {
            // Invalid login credentials
            response.sendRedirect("studentLogin.jsp?error=Invalid Student ID or Password");
        }
    } catch (Exception e) {
        e.printStackTrace(); // Print stack trace for debugging
        out.println("<p style='color:red;'>An error occurred: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
