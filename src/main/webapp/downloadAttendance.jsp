<%@ page import="java.sql.*, java.io.*" %>
<%
    // Get course ID from the request
    int courseId = Integer.parseInt(request.getParameter("courseId"));

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String jdbcUrl = "jdbc:mysql://localhost:3306/final";  // Update with your DB
    String dbUser = "root";  // Update with your DB user
    String dbPassword = "Parth@007";  // Update with your DB password

    // Setting content type for the response
    response.setContentType("text/html");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        h1 {
            color: #333;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .btn {
            display: inline-block;
            padding: 10px 15px;
            margin: 20px 0;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            text-decoration: none;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

    <h1>Attendance Report for Course ID: <%= courseId %></h1>

    <table>
        <thead>
            <tr>
                <th>Student Name</th>
                <th>Attendance Percentage</th>
            </tr>
        </thead>
        <tbody>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        // Query to fetch student names, attended lectures, and total sessions
        String sql = "SELECT s.s_name, s.total_attended, c.total_sessions " +
                     "FROM Students s " +
                     "JOIN courses c ON s.course_id = c.c_id " +
                     "WHERE c.c_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, courseId);
        rs = ps.executeQuery();

        // Write student data to HTML table
        while (rs.next()) {
            String studentName = rs.getString("s_name");
            int totalAttended = rs.getInt("total_attended");
            int totalSessions = rs.getInt("total_sessions");

            // Calculate attendance percentage
            double attendancePercentage = totalSessions > 0 ? ((double) totalAttended / totalSessions) * 100 : 0;

            // Display data in table rows
%>
            <tr>
                <td><%= studentName %></td>
                <td><%= String.format("%.2f%%", attendancePercentage) %></td>
            </tr>
<%
        }

    } catch (Exception e) {
        e.printStackTrace();
%>
            <tr>
                <td colspan="2">Error fetching data: <%= e.getMessage() %></td>
            </tr>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
        </tbody>
    </table>

    <a href="downloadAttendanceCSV.jsp?courseId=<%= courseId %>" class="btn">Download Attendance CSV</a>

</body>
</html>
