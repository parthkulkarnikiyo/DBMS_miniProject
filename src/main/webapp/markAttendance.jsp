<%@ page import="java.sql.*, java.util.*" %>
<%
    // Get course ID and attendance data from the request
    String[] attendanceList = request.getParameterValues("attendance");
    int courseId = Integer.parseInt(request.getParameter("courseId"));

    String jdbcUrl = "jdbc:mysql://localhost:3306/final";  // Update with your DB
    String dbUser = "root";  // Update with your DB user
    String dbPassword = "Parth@007";  // Update with your DB password

    // Using try-with-resources for automatic resource management
    try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Increment the total sessions for the course
        String sessionCountSql = "UPDATE courses SET total_sessions = total_sessions + 1 WHERE c_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sessionCountSql)) {
            ps.setInt(1, courseId);
            ps.executeUpdate();
        }

        // Update each student's attendance count
        if (attendanceList != null) {
            for (String studentName : attendanceList) {
                // Find the student ID based on the name
                String studentIdSql = "SELECT studentId FROM students WHERE studentName = ?";
                try (PreparedStatement ps = conn.prepareStatement(studentIdSql)) {
                    ps.setString(1, studentName);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            int studentId = rs.getInt("studentId");
                            
                            // Increment the total attended lectures for the student
                            String updateAttendanceSql = "UPDATE students SET total_attended = total_attended + 1 WHERE studentId = ?";
                            try (PreparedStatement updatePs = conn.prepareStatement(updateAttendanceSql)) {
                                updatePs.setInt(1, studentId);
                                updatePs.executeUpdate();
                            }
                        } else {
                            // If the student name is not found, handle it appropriately
                            out.println("<p style='color:red;'>Student " + studentName + " not found.</p>");
                        }
                    }
                }
            }
        }

        // Display success message
        out.println("<!DOCTYPE html>");
        out.println("<html lang='en'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Attendance Marked</title>");
        out.println("<style>");
        out.println("body { font-family: 'Arial', sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }");
        out.println(".container { max-width: 800px; margin: 40px auto; padding: 20px; border-radius: 8px; background-color: #ffffff; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); }");
        out.println("h2 { color: #4caf50; text-align: center; }");
        out.println("p { font-size: 16px; color: #333; text-align: center; }");
        out.println("input[type='submit'] { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; background-color: #4caf50; color: white; font-size: 16px; }");
        out.println("input[type='submit']:hover { background-color: #45a049; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h2>Attendance Marked Successfully!</h2>");
        out.println("<p>Your attendance has been recorded.</p>");

        // Add download button
        out.println("<form method='get' action='downloadAttendanceCSV.jsp' style='text-align: center; margin-top: 20px;'>");
        out.println("<input type='hidden' name='courseId' value='" + courseId + "'>"); // Hidden input to send course ID
        out.println("<input type='submit' value='View Attendance'>");
        out.println("</form>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");

    } catch (Exception e) {
        e.printStackTrace(); // Print stack trace for debugging
        out.println("<p style='color:red;'>An error occurred while marking attendance: " + e.getMessage() + "</p>");
    }
%>
