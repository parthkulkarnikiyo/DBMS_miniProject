<%@ page import="java.sql.*" %>

<%
    // Get the logged-in teacher ID from the session
    Integer teacherId = (Integer) session.getAttribute("teacherId");

    if (teacherId == null) {
        response.sendRedirect("login.jsp");
        return;
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

        // Query to fetch the courses for the logged-in teacher
        String sql = "SELECT c_name FROM courses WHERE tid = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, teacherId);
        rs = ps.executeQuery();

        // Start outputting HTML
        out.println("<html>");
        out.println("<head>");
        out.println("<title>My Courses</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; }");
        out.println("h2 { color: #333; }");
        out.println("ul { list-style-type: none; padding: 0; }");
        out.println("li { background: #fff; margin: 5px 0; padding: 10px; border: 1px solid #ccc; border-radius: 5px; display: flex; justify-content: space-between; align-items: center; }");
        out.println(".course-button { background-color: #007bff; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; text-decoration: none; }");
        out.println(".course-button:hover { background-color: #0056b3; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");

        out.println("<h2>Courses Conducted by You:</h2>");
        out.println("<ul>");

        // Display courses in an unordered list with buttons
        while (rs.next()) {
        	
            String courseName = rs.getString("c_name");
            out.println("<li>");
            out.println(courseName);
            // Add a button that redirects to addSession.jsp
            out.println("<a href='addSession.jsp?courseName=" + courseName + "' class='course-button'>Add Session</a>");
        }
        out.println("</ul>");

        out.println("</body>");
        out.println("</html>");

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
