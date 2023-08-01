<%@page import="java.sql.*" %>
  <%@page import="java.util.*" %>
    <%@page import="java.text.*" %>
      <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="en" xmlns:th="http://www.thymeleaf.org" xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity3">

          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="ie=edge">
            <script src="https://code.jquery.com/jquery-3.7.0.slim.min.js" integrity="sha256-tG5mcZUtJsZvyKAxYLVXrmjKBVLd6VpVccqz/r4ypFE=" crossorigin="anonymous"></script>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Autour+One&family=Cabin:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&display=swap" rel="stylesheet">
            <link rel="stylesheet" type="text/css" href="style.css">
            <title>Store Front</title>

            <script type="text/javascript">
              let slideIndex = 1;
              let pauseAutoSlide = false;
              const slideInterval = 3000;

              function changeSlide(x) {
                showSlides(slideIndex += x);
              }

              function showSlides(x) {
                let slides = document.querySelectorAll("#store-carousel .product");

                if (x > slides.length)
                  slideIndex = 1;

                if (x < 1)
                  slideIndex = slides.length;

                for (let i = 0; i < slides.length; i++)
                  slides[i].style.display = "none";

                slides[slideIndex - 1].style.display = "block";
              }

              function autoSlide() {
                changeSlide(pauseAutoSlide ? 0 : 1);
                setTimeout(autoSlide, slideInterval);
              }

              $(document).ready(function () {
                autoSlide();

                $(document).on("keydown", function (e) {
                  // moves the carousel to the left or right with the arrow keys
                  if (e.keyCode == 37) // left arrow
                    changeSlide(-1);
                  else if (e.keyCode == 39) // right arrow
                    changeSlide(1);

                  // close the dropdowns if the escape key is pressed
                  if (e.keyCode == 27) {
                    $(".store-unit-dropdown").hide();
                    pauseAutoSlide = false;
                  }
                });

                $(".product").on("click", function (e) {
                  let dropdown = $(this).find(".store-unit-dropdown");

                  // close the dropdowns if the user clicks outside of them
                  if (e.target.classList.value.includes("product") && dropdown.is(":visible")) {
                    dropdown.hide();
                    pauseAutoSlide = false;
                  }
                });

                $(".btn-basket-carousel").on("click", function () {
                  $(this).nextAll(".store-unit-dropdown-basket").toggle();
                  pauseAutoSlide = true;
                });
                $(".btn-custombasket-carousel").on("click", function () {
                  $(this).nextAll(".store-unit-dropdown-custombasket").toggle();
                  pauseAutoSlide = true;
                });

                $(".btn-basket").on("click", function () {
                  $(this).nextAll(".store-unit-dropdown").toggle();
                });
                $(".btn-custombasket").on("click", function () {
                  $(this).nextAll(".store-unit-dropdown").toggle();
                });

                $(".unit-add-button").on("click", function () {
                  fetch("basket/add?" + new URLSearchParams({
                    id: $(this).parent().find(".product-id").text(),
                    quantity: parseInt($(this).parent().find(".unit-count").text()),
                  }), {
                    method: "POST",
                  });

                  $(".unit-remove").on("click", function () {
                    fetch("/basket/clear?" + new URLSearchParams({
                      id: $(this).parent().find(".product-id").text(),
                      quantity: parseInt($(this).parent().find(".unit-count").text()),
                    }), {
                      method: "POST",
                  });
                  $("#remove-all").on("click", function () {
                    fetch("basket/clear", {
                      method: "POST",
                    }).then(response => {
                      location.reload();
                    });


                  $(this).parent(".store-unit-dropdown").toggle();
                  $(this).parent().find(".unit-count").text("1");

                  if ($(".store-unit-dropdown-basket").is(":notvisible") && $(".store-unit-dropdown-custombasket").is(":notvisible"))
                    pauseAutoSlide = false;
                });

                $(".product").on("click", ".unit-increment-button", function () {
                  var unitCountSpan = $(this).siblings(".unit-count");
                  var unitCount = parseInt(unitCountSpan.text(), 10);
                  unitCount++;
                  unitCountSpan.text(unitCount.toString());
                });
                $(".product").on("click", ".unit-decrement-button", function () {
                  var unitCountSpan = $(this).siblings(".unit-count");
                  var unitCount = parseInt(unitCountSpan.text(), 10);
                  if (unitCount > 0)
                    unitCount--;
                  else
                    unitCount = 0;
                  unitCountSpan.text(unitCount.toString());
                });

                let isCustomBasket = false;

                let basket = $("#basket");
                let customBasket = $("#custom-basket");

                // Toggle between the two baskets
                $(".basket-type-switch").on("click", toggleBasketType);

                // Redirect to the admin portal
                $("#admin-btn").on("click", () => location.href = "admin");

                // Logout
                $("#logout-btn").on("click", () => location.href = "userlogout");

                // dismisses the welcome dialog with the correct side-effect
                $("#welcome-dialog #no-btn").on("click", closeWelcomeDialog);
                $("#welcome-dialog #yes-btn").on("click", closeWelcomeDialog); //todo: add the correct side-effect

                // Opens the basket overlay
                let nowDate = Date.now();

                if (localStorage.getItem("welcomeDialogTime") == null || (nowDate - localStorage.getItem("welcomeDialogTime")) / (1000 * 60) > 5)
                  setTimeout(function () {
                    localStorage.setItem("welcomeDialogTime", Date.now());
                    openWelcomeDialog();
                  }, 1000);

                // Opens the welcome dialog
                function openWelcomeDialog() {
                  $("#welcome-dialog").addClass("enabled");
                  $("#welcome-dialog").removeClass("disabled");

                  $(document.body).addClass("unscrollable");
                  $(document.body).removeClass("scrollable");
                }

                // Closes the welcome dialog
                function closeWelcomeDialog() {
                  $("#welcome-dialog").addClass("disabled");
                  $("#welcome-dialog").removeClass("enabled");

                  $(document.body).addClass("scrollable");
                  $(document.body).removeClass("unscrollable");
                }

                // Opens the basket overlay
                function openBasketOverlay() {
                  $(".basket #overlay").trigger("basketOverlayOpen");
                }

                // Closes the basket overlay
                function closeBasketOverlay() {
                  $(".basket #overlay").trigger("basketOverlayClose");
                }

                // Toggle between login and register
                function toggleBasketType() {
                  isCustomBasket = !isCustomBasket;

                  updateBasket();
                }

                // Updates the currently displayed basket
                function updateBasket() {
                  if (isCustomBasket) {
                    customBasket.removeClass("disabled");
                    customBasket.addClass("enabled");
                    basket.addClass("disabled");
                    basket.removeClass("enabled");
                  } else {
                    customBasket.addClass("disabled");
                    customBasket.removeClass("enabled");
                    basket.addClass("enabled");
                    basket.removeClass("disabled");
                  }
                }
              });
            </script>
          </head>

          <!-- Welcome Dialog -->
          <div id="welcome-dialog" class="disabled">
            <div id="welcome-content">
              <img id="logo" src="images/nyan_logo_nobg_large.png" alt="Nyan Groceries icon">
              <span id="title">Welcome back!</span>
              <span id="content">Do you want to start from your custom basket?</span>
              <div id="actions">
                <a id="yes-btn" class="btn">Yes</a>
                <a id="no-btn" class="btn">No</a>
              </div>
            </div>
          </div>

          <header>
            <img id="logo" src="images/nyan_logo_nobg.png" alt="Store icon" width="48px" height="48px">

            <h3>
              Nyan Groceries
            </h3>

            <c:if test="${user.getRole() == 'ROLE_ADMIN'}">
              <img id="admin-btn" src="images/icons/admin.png" alt="Admin portal icon" class="btn btn-icon">
            </c:if>

            <img id="logout-btn" src="images/icons/exit.png" alt="Logout icon" class="btn btn-icon">
          </header>

          <body id="store-body">

            <!-- Storefront -->
            <div id="storefront">

              <!-- Product Carousel -->
              <div id="store-carousel">
                <div class="carousel-wrapper">
                  <c:forEach var="product" items="${products}" varStatus="loopStatus">
                    <c:if test="${loopStatus.index < 3}">
                      <div class="product">
                        <div class="product-details">
                          <h5 class="product-name">${product.name}</h5>
                          <h5 class="product-price">$${product.price}</h5>
                        </div>
                        <img class="product-img" src="${product.image}" alt="Product">
                        <div class="product-buttons">
                          <a class="btn btn-primary btn-basket-carousel"><img src="images/icons/basket.png" alt="Basket" width="40"></a>
                          <div class="store-unit-dropdown store-unit-dropdown-basket">
                            <div class="unit-selection-box">
                              <span hidden class="product-id">${product.id}</span>
                              <span class="unit-count">1</span>
                              <button class="unit-increment-button"><img src="images/icons/dropdown_arrow.png" alt="Up arrow" width="12"></button>
                              <button class="unit-decrement-button"><img src="images/icons/dropdown_arrow.png" alt="Down arrow" width="12"></button><br>
                            </div>
                            <button class="unit-add-button carousel">Add</button>
                          </div>
                          <a class="btn btn-primary btn-custombasket-carousel"><img src="images/icons/custombasket.png" alt="Basket" width="40"></a>
                          <div class="store-unit-dropdown store-unit-dropdown-custombasket">
                            <div class="unit-selection-box">
                              <span hidden class="product-id">${product.id}</span>
                              <span class="unit-count">1</span>
                              <button class="unit-increment-button"><img src="images/icons/dropdown_arrow.png" alt="Up arrow" width="12"></button>
                              <button class="unit-decrement-button"><img src="images/icons/dropdown_arrow.png" alt="Down arrow" width="12"></button><br>
                            </div>
                            <button class="unit-add-button carousel">Add</button>
                          </div>
                        </div>
                      </div>
                    </c:if>
                  </c:forEach>
                </div>
                <button class="carousel-btn carousel-left-btn" onclick="changeSlide(-1)"><img src="images/icons/arrow_left.png" alt="Left arrow" width="30"></button>
                <button class="carousel-btn carousel-right-btn" onclick="changeSlide(1)"><img src="images/icons/arrow_right.png" alt="Right arrow" width="30"></button>
              </div>

              <!-- Store List -->
              <div id="store-list">
                <c:forEach var="product" items="${products}">
                  <div class="product">
                    <img class="product-img" src="${product.image}" alt="Product">
                    <div class="product-details">
                      <h5 class="product-name">${product.name}</h5>
                      <h5 class="product-price">$${product.price}</h5>
                    </div>
                    <div class="product-buttons">
                      <a class="btn btn-primary btn-basket"><img src="images/icons/basket.png" alt="Basket" width="25">
                      </a>
                      <a class="btn btn-primary btn-custombasket"><img src="images/icons/custombasket.png" alt="Basket" width="25"></a>
                      <div class="store-unit-dropdown">
                        <div class="unit-selection-box">
                          <span hidden class="product-id">${product.id}</span>
                          <span class="unit-count">1</span>
                          <button class="unit-increment-button"><img src="images/icons/dropdown_arrow.png" alt="Up arrow" width="12"></button>
                          <button class="unit-decrement-button"><img src="images/icons/dropdown_arrow.png" alt="Down arrow" width="12"></button><br>
                        </div>
                        <button class="unit-add-button">Add</button>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </div>

            <!-- Baskets -->
            <div id="baskets-container">
              <jsp:include page="basket.jsp">
                <jsp:param name="visibility" value="enabled" />
                <jsp:param name="type" value="basket" />
                <jsp:param name="name" value="Basket" />
                <jsp:param name="basketSubtotalUntilCoupon" value="17.62" />
              </jsp:include>

              <jsp:include page="basket.jsp">
                <jsp:param name="visibility" value="disabled" />
                <jsp:param name="type" value="custom-basket" />
                <jsp:param name="name" value="Custom Basket" />
                <jsp:param name="basketSubtotalUntilCoupon" value="17.62" />
              </jsp:include>
            </div>

          </body>

        </html>