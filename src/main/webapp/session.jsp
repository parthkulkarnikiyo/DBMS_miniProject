<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get course name from request parameter
    String courseName = request.getParameter("courseName");
    
    if (courseName == null) {
        out.println("<p style='color:red;'>Course name not provided.</p>");
        return; // Exit if no course name is provided
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String jdbcUrl = "jdbc:mysql://localhost:3306/final";  // Update with your DB
    String dbUser = "root";  // Update with your DB user
    String dbPassword = "Parth@007";  // Update with your DB password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        // Query to fetch the course ID based on course name
        String sql = "SELECT c_id FROM courses WHERE c_name = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, courseName);
        rs = ps.executeQuery();

        int courseId = 0;
        if (rs.next()) {
            courseId = rs.getInt("c_id");
        } else {
            out.println("<p style='color:red;'>Course not found.</p>");
            return; // Exit if course ID not found
        }

        // Query to fetch all students (no filtering by course)
        String studentSql = "SELECT studentName FROM students";  // Changed from Students to students (case-sensitive)
        ps = conn.prepareStatement(studentSql);
        rs = ps.executeQuery();

        // Adding styles inline to the output
        out.println("<html lang='en'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Mark Attendance</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }");
        out.println(".container { max-width: 800px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println("h2 { color: #333; }");
        out.println("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        out.println("th, td { padding: 10px; text-align: left; border: 1px solid #ddd; }");
        out.println("th { background-color: #f2f2f2; }");
        out.println("input[type='checkbox'] { transform: scale(1.5); margin: 0; }");
        out.println("input[type='submit'] { padding: 10px 15px; background-color: #5cb85c; border: none; color: white; border-radius: 5px; cursor: pointer; }");
        out.println("input[type='submit']:hover { background-color: #4cae4c; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<div class='container'>");
        out.println("<h2>Students enrolled in " + courseName + " (Course ID: " + courseId + "):</h2>");
        out.println("<form method='post' action='markAttendance.jsp'>"); // Change the action to your attendance processing page
        out.println("<table><tr><th>Student Name</th><th>Attendance</th></tr>");

        // Display all students with checkboxes for attendance
        while (rs.next()) {
            String studentName = rs.getString("studentName");
            out.println("<tr><td>" + studentName + "</td><td><input type='checkbox' name='attendance' value='" + studentName + "'></td></tr>");
        }
        out.println("</table>");
        out.println("<input type='hidden' name='courseId' value='" + courseId + "'> // This should be included in the form"); // Hidden input to send course ID
        out.println("<input type='submit' value='Mark Attendance'>");
        out.println("</form>");
        out.println("</div>"); // Closing container
        out.println("</body>");
        out.println("</html>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red;'>An error occurred while processing your request.</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
