<%@ page import="java.io.*" %>
<%
    String csvData = request.getParameter("csvData");

    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment; filename=\"attendance_report.csv\"");

    try (PrintWriter writer = response.getWriter()) {
        writer.println("Student Name,Total Attended");
        writer.print(csvData); // Write the CSV data to the response
    } catch (IOException e) {
        e.printStackTrace(); // Print stack trace for debugging
    }
%>
