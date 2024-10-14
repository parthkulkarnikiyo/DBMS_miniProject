<%@ page import="java.sql.*, java.io.*" %>
<%
    // Get the course ID from request parameters
    int courseId = Integer.parseInt(request.getParameter("courseId"));
    
    String jdbcUrl = "jdbc:mysql://localhost:3306/final";  // Update with your DB
    String dbUser = "root";  // Update with your DB user
    String dbPassword = "Parth@007";  // Update with your DB password

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        // SQL query to fetch student names and their attendance
        String sql = "SELECT studentName, total_attended FROM students";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        // Prepare data for CSV
        StringBuilder csvBuilder = new StringBuilder();
        csvBuilder.append("Student Name,Attendance Percentage\n");

        // First, get the total number of sessions for the course
        int totalSessions = 0;
        String totalSessionsSql = "SELECT total_sessions FROM courses WHERE c_id = ?";
        ps = conn.prepareStatement(totalSessionsSql);
        ps.setInt(1, courseId);
        ResultSet sessionRs = ps.executeQuery();
        
        if (sessionRs.next()) {
            totalSessions = sessionRs.getInt("total_sessions");
        }

        // Output HTML
        out.println("<!DOCTYPE html>");
        out.println("<html lang='en'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Attendance Report</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }");
        out.println(".container { max-width: 800px; margin: 40px auto; padding: 20px; border-radius: 8px; background-color: #ffffff; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); }");
        out.println("h2 { color: #4caf50; text-align: center; }");
        out.println("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        out.println("th, td { padding: 10px; text-align: left; border: 1px solid #ddd; }");
        out.println("th { background-color: #f2f2f2; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h2>Attendance Report for Course ID: " + courseId + "</h2>");
        out.println("<table><tr><th>Student Name</th><th>Attendance Percentage</th></tr>");

        // Process result set
        while (rs.next()) {
            String studentName = rs.getString("studentName");
            int totalAttended = rs.getInt("total_attended");

            // Calculate attendance percentage
            double attendancePercentage = (totalSessions > 0) ? (double) totalAttended / totalSessions * 100 : 0.0;

            out.println("<tr><td>" + studentName + "</td><td>" + String.format("%.2f", attendancePercentage) + "%</td></tr>");

            // Append to CSV data
            csvBuilder.append(studentName).append(",").append(String.format("%.2f", attendancePercentage)).append("\n");
        }
        out.println("</table>");

        // Provide option to download CSV
        out.println("<form method='post' action='downloadCSV.jsp' style='text-align: center; margin-top: 20px;'>");
        out.println("<input type='hidden' name='csvData' value='" + csvBuilder.toString().replace("\"", "&quot;") + "'/>"); // Pass CSV data as hidden field
        out.println("<input type='submit' value='Download Attendance CSV'>");
        out.println("</form>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");

    } catch (Exception e) {
        e.printStackTrace(); // Print stack trace for debugging
        out.println("<p style='color:red;'>An error occurred: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
