<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Login</title>
</head>
<body style="background-color: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; font-family: Arial, sans-serif;">

    <div style="background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); width: 300px; text-align: center;">
        <h2 style="margin-bottom: 20px;">Teacher Login</h2>
        
        <form action="AfterLogin.jsp" method="post">
            <div style="margin-bottom: 15px; text-align: left;">
                <label for="teacherName" style="font-size: 14px; color: #333;">Teacher Name</label>
                <input type="text" id="teacherName" name="teacherName" required
                       style="width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px;">
            </div>
            <div style="margin-bottom: 15px; text-align: left;">
                <label for="password" style="font-size: 14px; color: #333;">Password</label>
                <input type="password" id="password" name="password" required
                       style="width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px;">
            </div>
            <button type="submit" style="width: 100%; padding: 10px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; transition: background-color 0.3s ease;">
                Login
            </button>
        </form>
    </div>

</body>
</html>
