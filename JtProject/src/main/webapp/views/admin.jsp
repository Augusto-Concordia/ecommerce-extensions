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

								// Add new product to the store
								$("#add-btn").on("click", function () {
									$("#product-img").attr("src", "images/nyan_logo_nobg_large.png");
									$("#product-img-url").val("");
									$("#product-name").val("");
									$("#product-quantity").val("");
									$("#product-price").val("");

									changeEditorVisibility(true);
								});

								// Edit product on the store
								$(".edit-button").each(function (i, e) {
									$(e).on("click", function () {
										// Get the product details
										let product = $(e).parent().parent().parent().children(".product-details").children(".product-details-left");

										console.log(product);

										// Set the selected product details
										$("#product-img").attr("src", product.parent().parent().children(".product-img").attr("src"));
										$("#product-img-url").val(product.children(".product-img").attr("src"));
										$("#product-name").val(product.children(".product-name").text());
										$("#product-quantity").val(product.children(".product-quantity").text().replace("(", "").replace("x)", ""));
										$("#product-price").val(product.siblings().children(".product-price").text().replace("$", ""));

										// Set the selected product pairing
										let pairing = product.children(".product-pairing").text().replace("with ", "").replace(" (", ",").replace(" recommended)", "").split(",");

										//todo: set the selected product pairing to the correct value
										$("#product-pairing").val(pairing[0]);

										changeEditorVisibility(true);
									});

									// Delete product from store
									$(".delete-button").on("click", () => location.href = "editproduct");

									// Update the selected product image
									$("#product-img-url").on("change", () => {
										let newUrl = $("#product-img-url").val() == "" ? "images/nyan_logo_nobg_large.png" : $("#product-img-url").val();

										$("#product-img").attr("src", newUrl);
									});
								});

								function changeEditorVisibility(visible) {
									if (visible) {
										// Enable the selected product
										$("#selected-product-content").children(".selection").removeClass("disabled");
										$("#selected-product-content").children(".selection").addClass("enabled");

										$("#selected-product-content").children(".no-selection").removeClass("enabled");
										$("#selected-product-content").children(".no-selection").addClass("disabled");
									} else {
										// Enable the selected product
										$("#selected-product-content").children(".selection").addClass("disabled");
										$("#selected-product-content").children(".selection").removeClass("enabled");

										$("#selected-product-content").children(".no-selection").addClass("enabled");
										$("#selected-product-content").children(".no-selection").removeClass("disabled");
									}
								}
							});
						</script>
					</head>

					<header>
						<img id="logo" src="images/nyan_logo_nobg.png" alt="Store icon" width="48px" height="48px">

						<h3>
							Nyan Groceries <span id="admin-label">Admin</span>
						</h3>

						<img id="add-btn" src="images/icons/add.png" alt="Add new product icon" class="btn btn-icon">

						<img id="store-btn" src="images/icons/store.png" alt="Store front icon" class="btn btn-icon">

						<img id="logout-btn" src="images/icons/exit.png" alt="Logout icon" class="btn btn-icon">
					</header>

					<body id="admin-body">

						<div id="admin-container">
							<!-- Product List -->
							<section id="admin-products">
								<c:forEach var="product" items="${products}">
									<div class="product">
										<img class="product-img" src="${product.image}" alt="Product">
										<div class="product-details">
											<div class="product-details-left">
												<h5 class="product-name">${product.name}</h5>
												<h5 class="product-quantity">(${product.quantity}x)</h5><br>
												<h5 class="product-pairing">with <span class="paired-product">Banana</span> (<span class="recommended-product">Pears</span> recommended)</h5>
											</div>
											<div class="product-details-right">
												<h5 class="product-price">$${product.price}</h5>
												<button id="edit-button" class="edit-button"><img src="images/icons/edit.png" alt="Edit icon" width="40"></button>
												<button id="delete-button"><img src="images/icons/delete.png" alt="Trash icon" width="40"></button>
											</div>
										</div>
									</div>
								</c:forEach>
							</section>

							<!-- Selected Product -->
							<section id="selected-product">
								<div id="selected-product-content">
									<!-- No product selected -->
									<div class="no-selection enabled">
										No Product<br />Selected
									</div>

									<!-- Product selected -->
									<div class="selection disabled">
										<span id="title">Editor</span>
										<div id="selected-product-details">

											<img id="product-img" src="images/nyan_logo_nobg_large.png" alt="Product image">
											<form action="products/update/id" method="post" id="selected-product-details-right">
												<label for="product-img-url">Image</label>
												<input id="product-img-url" required placeholder="https://image.com" type="url"></input>

												<label for="product-name">Name</label>
												<input id="product-name" required placeholder="Banana" type="text"></input>

												<label for="product-quantity">Quantity</label>
												<input id="product-quantity" required placeholder="619" type="number"></input>

												<label for="product-price">Price (CA$/u)</label>
												<input id="product-price" required placeholder="4.02" type="number"></input>

												<label for="product-pairing">Select Pair</label>
												<select id="product-pairing">
													<option value="0">None</option>
													<option value="1">Banana</option>
													<option value="2">Apple</option>
													<option value="3">Orange</option>
													<option value="4">Pear</option>
												</select>

												<input id="product-submit" class="btn" type="submit" value="Finish"></input>
											</form>
										</div>
									</div>
							</section>
						</div>
					</body>

				</html>