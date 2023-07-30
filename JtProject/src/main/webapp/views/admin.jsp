<%@page import="java.sql.*" %>
	<%@page import="java.util.*" %>
		<%@page import="java.text.*" %>
			<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

				<!DOCTYPE html>
				<html lang="en" xmlns:th="http://www.thymeleaf.org" xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity3">

					<head>
						<meta charset="UTF-8">
						<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
						<meta http-equiv="X-UA-Compatible" content="ie=edge">
						<script src="https://code.jquery.com/jquery-3.7.0.slim.min.js" integrity="sha256-tG5mcZUtJsZvyKAxYLVXrmjKBVLd6VpVccqz/r4ypFE=" crossorigin="anonymous"></script>
						<link rel="preconnect" href="https://fonts.googleapis.com">
						<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
						<link href="https://fonts.googleapis.com/css2?family=Autour+One&family=Cabin:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&display=swap" rel="stylesheet">
						<link rel="stylesheet" type="text/css" href="style.css">
						<title>Store Front</title>

						<script type="text/javascript">
							$(document).ready(function () {
								// Redirect to the admin portal
								$("#store-btn").on("click", () => location.href = "/");

								// Logout
								$("#logout-btn").on("click", () => location.href = "userlogout");
							});
						</script>
					</head>

					<header>
						<img id="logo" src="images/nyan_logo_nobg.png" alt="Store icon" width="48px" height="48px">

						<h3>
							Nyan Groceries
						</h3>

						<img id="add-btn" src="images/icons/add.png" alt="Add new product icon" class="btn btn-icon">

						<img id="store-btn" src="images/icons/store.png" alt="Store front icon" class="btn btn-icon">

						<img id="logout-btn" src="images/icons/exit.png" alt="Logout icon" class="btn btn-icon">
					</header>

					<body id="admin-body">

					</body>

				</html>