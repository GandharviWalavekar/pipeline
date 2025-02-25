<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
    String user = request.getParameter("user");
    String password = request.getParameter("password");

    // Hardcoded credentials (Vulnerability: Security-sensitive issue)
    String hardcodedUser = "admin";
    String hardcodedPassword = "password123";

    boolean isAuthenticated = false;

    if (user != null && password != null) {
        if (user.equals(hardcodedUser) && password.equals(hardcodedPassword)) {
            isAuthenticated = true;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome to Hackers' Paradise</title>
    <style>
        /* Basic Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        /* Body & Container styling inspired by Bootstrap */
        body {
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
            padding: 40px 10px;
        }
        .container {
            max-width: 500px;
            margin: auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 0.25rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        h1, h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        p {
            text-align: center;
            margin-bottom: 20px;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        input[type="text"],
        input[type="password"] {
            margin-bottom: 10px;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            font-size: 1rem;
        }
        input[type="submit"] {
            background-color: #007bff;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 0.25rem;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.15s ease-in-out;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Hackers' Paradise</h1>
        <p>Enter your credentials and see if you belong here.</p>

        <% if (!isAuthenticated) { %>
            <form method="post">
                <input type="text" name="user" placeholder="Username" required>
                <input type="password" name="password" placeholder="Password" required>
                <input type="submit" value="Login">
            </form>
        <% } else { %>
            <h2>Welcome, <%= user %>!</h2> <!-- XSS Vulnerability: Direct user input output -->
            <p>You have successfully logged in. Enjoy your stay!</p>
        <% } %>
    </div>
</body>
</html>
