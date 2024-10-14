<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Attendance Session</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; }
        h2 { color: #333; }
        .container { background: white; padding: 20px; border-radius: 5px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        input[type="date"] { padding: 10px; margin: 10px 0; width: 100%; }
        input[type="submit"] { background-color: #007bff; color: white; border: none; padding: 10px; border-radius: 5px; cursor: pointer; }
        input[type="submit"]:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<div class="container">
    <h2>Create Attendance Session</h2>
    <%
        // Get the logged-in teacher ID and course name from the session
        Integer teacherId = (Integer) session.getAttribute("teacherId");
        String courseName = request.getParameter("courseName");

        if (teacherId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Check if the form is submitted
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String sessionDateStr = request.getParameter("sessionDate");

            if (sessionDateStr != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                PreparedStatement psUpdate = null;

                String jdbcUrl = "jdbc:mysql://localhost:3306/final";  // Update with your DB
                String dbUser = "root";  // Update with your DB user
                String dbPassword = "Parth@007";  // Update with your DB password

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

                    // Here you can insert the session details into your Attendance table
                    // For this example, let's assume you have a sessions table
                    // We'll also update the total_sessions in the courses table

                    // Step 1: Update the total_sessions for the course
                    String updateSql = "UPDATE courses SET total_sessions = total_sessions + 1 WHERE c_name = ?";
                    psUpdate = conn.prepareStatement(updateSql);
                    psUpdate.setString(1, courseName);
                    psUpdate.executeUpdate();

                    // Step 2: Insert the session into the sessions table (assuming you have one)
                    // String insertSql = "INSERT INTO sessions (courseId, sessionDate) VALUES (?, ?)";
                    // ps = conn.prepareStatement(insertSql);
                    // ps.setInt(1, courseId); // Get courseId based on courseName if necessary
                    // ps.setString(2, sessionDateStr);
                    // ps.executeUpdate();

                    // Redirect to session.jsp with the selected course
                    response.sendRedirect("session.jsp?courseName=" + courseName + "&sessionDate=" + sessionDateStr);
                    return;

                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (ps != null) ps.close();
                    if (psUpdate != null) psUpdate.close();
                    if (conn != null) conn.close();
                }
            }
        }
    %>

    <form action="addSession.jsp?courseName=<%= courseName %>" method="post">
        <label for="sessionDate">Select Session Date:</label>
        <input type="date" id="sessionDate" name="sessionDate" required>
        <input type="submit" value="Create Session">
    </form>
</div>
</body>
</html>
