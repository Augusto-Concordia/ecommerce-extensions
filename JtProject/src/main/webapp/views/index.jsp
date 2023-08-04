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
              let isCustomBasket = false;
              let basket = null;
              let customBasket = null;
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
                if (localStorage.getItem("hasNewProduct") == "true") {
                  localStorage.setItem("hasNewProduct", "false");
                  setTimeout(openBasketOverlay, 2000);
                  setTimeout(closeBasketOverlay, 8000);
                }

                // if the user had a basket open, open it again
                basket = $("#basket");
                customBasket = $("#custom-basket");
                isCustomBasket = localStorage.getItem("currentBasket") == "custom-basket";
                updateBasket();

                $(".basket #overlay").on("click", function () {
                  closeBasketOverlay();
                });

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

                $(".btn-basket").on("click", function () {
                  $(this).nextAll(".store-unit-dropdown-basket").toggle();

                  if ($(this).hasClass("btn-basket-carousel"))
                    pauseAutoSlide = true;
                });
                $(".btn-custombasket").on("click", function () {
                  $(this).nextAll(".store-unit-dropdown-custombasket").toggle();

                  if ($(this).hasClass("btn-custombasket-carousel"))
                    pauseAutoSlide = true;
                });

                $(".store-unit-dropdown-basket .unit-add-button").on("click", function () {
                  fetch("basket/add?" + new URLSearchParams({
                    user_id: $("#current_user").text(),
                    id: $(this).parentsUntil(".product").siblings(".product-id").text(),
                    quantity: parseInt($(this).siblings(".unit-selection-box").find(".unit-count").text())
                  }), {
                    method: "POST",
                  }).then(response => {
                    localStorage.setItem("hasNewProduct", "true");
                    localStorage.setItem("currentBasket", "basket");
                    location.reload();
                  });

                  $(this).parent(".store-unit-dropdown").toggle();
                  $(this).parent().find(".unit-count").text("1");

                  if (!$(".store-unit-dropdown-basket").is(":visible") && !$(".store-unit-dropdown-custombasket").is(":visible"))
                    pauseAutoSlide = false;
                });

                $(".store-unit-dropdown-custombasket .unit-add-button").on("click", function () {
                  fetch("basketcustom/add?" + new URLSearchParams({
                    user_id: $("#current_user").text(),
                    id: $(this).parentsUntil(".product").siblings(".product-id").text(),
                    quantity: parseInt($(this).siblings(".unit-selection-box").find(".unit-count").text())
                  }), {
                    method: "POST",
                  }).then(response => {
                    localStorage.setItem("hasNewProduct", "true");
                    localStorage.setItem("currentBasket", "custom-basket");
                    location.reload();
                  });

                  $(this).parent(".store-unit-dropdown").toggle();
                  $(this).parent().find(".unit-count").text("1");

                  if (!$(".store-unit-dropdown-basket").is(":visible") && !$(".store-unit-dropdown-custombasket").is(":visible"))
                    pauseAutoSlide = false;
                });

                $("#basket #small-product .btn.remove").each((i, e) => $(e).on("click", function () {
                  let product_id = $(e).parent().parent().find("#product-info #product-id").text();
                  // console.log(productId);
                  fetch("basket/removeitembasket?" + new URLSearchParams({
                    user_id: $("#current_user").text(),
                    product_id: product_id
                  }), {
                    method: "POST"
                  }).then(response => {
                    localStorage.setItem("currentBasket", "basket");
                    location.reload();
                  });
                }));

                $("#custom-basket #small-product .btn.add-basket").each((i, e) => $(e).on("click", function () {
                  let product_id = $(e).parent().parent().find("#product-info #product-id").text();
                  let quantity = $(e).parent().parent().find("#product-info #product-qty-pure").text();

                  fetch("basket/add?" + new URLSearchParams({
                    user_id: $("#current_user").text(),
                    id: product_id,
                    quantity: quantity
                  }), {
                    method: "POST",
                  }).then(response => {
                    localStorage.setItem("hasNewProduct", "true");
                    localStorage.setItem("currentBasket", "basket");
                    location.reload();
                  });
                }));

                $("#custom-basket #small-product .btn.remove").each((i, e) => $(e).on("click", function () {
                  let product_id = $(e).parent().parent().find("#product-info #product-id").text();
                  // console.log(productId);
                  fetch("basket/removeitemcustombasket?" + new URLSearchParams({
                    user_id: $("#current_user").text(),
                    product_id: product_id
                  }), {
                    method: "POST"
                  }).then(response => {
                    localStorage.setItem("currentBasket", "custom-basket");
                    location.reload();
                  });
                }));

                $("#basket #remove-all").on("click", function () {
                  fetch("basket/clear?" + new URLSearchParams({
                    user_id: $("#current_user").text()
                  }), {
                    method: "POST",
                  }).then(response => {
                    localStorage.setItem("currentBasket", "basket");
                    location.reload();
                  });
                });

                $("#custom-basket #remove-all").on("click", function () {
                  fetch("basketcustom/clear?" + new URLSearchParams({
                    user_id: $("#current_user").text()
                  }), {
                    method: "POST",
                  }).then(response => {
                    localStorage.setItem("currentBasket", "custom-basket");
                    location.reload();
                  });
                });

                $("#custom-basket #actions #basket-action").on("click", function () {
                  fetch("basket/export?" + new URLSearchParams({
                    userID: $("#current_user").text()
                  }), { method: "post" }).then(() => {
                    localStorage.setItem("currentBasket", "custom-basket");
                    location.reload();
                  });
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

                // Toggle between the two baskets
                $(".basket-type-switch").on("click", toggleBasketType);

                // Redirect to the admin portal
                $("#admin-btn").on("click", () => location.href = "admin");

                // Logout
                $("#logout-btn").on("click", () => location.href = "userlogout");

                // dismisses the welcome dialog with the correct side-effect
                $("#welcome-dialog #no-btn").on("click", closeWelcomeDialog);
                $("#welcome-dialog #yes-btn").on("click", function () {
                  closeWelcomeDialog();
                  isCustomBasket = true;
                  updateBasket();
                });

                // Opens the basket overlay
                let nowDate = Date.now();

                if (localStorage.getItem("welcomeDialogTime") == null || (nowDate - localStorage.getItem("welcomeDialogTime")) / (1000 * 60) > 5)
                  setTimeout(function () {
                    localStorage.setItem("welcomeDialogTime", Date.now());
                    openWelcomeDialog();
                  }, 1000);

                // Opens the welcome dialog
                function openWelcomeDialog() {
                  $("#welcome-dialog").addClass("soft-enabled");
                  $("#welcome-dialog").removeClass("soft-disabled");

                  $(document.body).addClass("unscrollable");
                  $(document.body).removeClass("scrollable");
                }

                // Closes the welcome dialog
                function closeWelcomeDialog() {
                  $("#welcome-dialog").addClass("soft-disabled");
                  $("#welcome-dialog").removeClass("soft-enabled");

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

                  localStorage.setItem("currentBasket", isCustomBasket ? "custom-basket" : "basket");

                  updateBasket();
                }

                // Updates the currently displayed basket
                function updateBasket() {
                  if (isCustomBasket) {
                    customBasket.removeClass("soft-disabled");
                    customBasket.addClass("soft-enabled");
                    basket.addClass("soft-disabled");
                    basket.removeClass("soft-enabled");
                  } else {
                    customBasket.addClass("soft-disabled");
                    customBasket.removeClass("soft-enabled");
                    basket.addClass("soft-enabled");
                    basket.removeClass("soft-disabled");
                  }
                }
              });

            </script>
          </head>

          <!-- Welcome Dialog -->
          <div id="welcome-dialog" class="soft-disabled">
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
          <span id="current_user" hidden>${user.id}</span>
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
                        <span hidden class="product-id">${product.id}</span>
                        <div class="product-details">
                          <h5 class="product-name">${product.name} <br>
                            <c:if test="${not empty product.pairedProduct.name}">
                              <span class="product-pairing"> paired with ${product.pairedProduct.name}</span>
                            </c:if>
                          </h5>
                          <h5 class="product-price">$${product.price}</h5>
                        </div>
                        <img class="product-img" src="${product.image}" alt="Product">
                        <div class="product-buttons">
                          <a class="btn btn-primary btn-basket btn-basket-carousel"><img src="images/icons/basket.png" alt="Basket" width="40"></a>
                          <div class="store-unit-dropdown store-unit-dropdown-basket">
                            <div class="unit-selection-box">
                              <span class="unit-count">1</span>
                              <button class="unit-increment-button"><img src="images/icons/dropdown_arrow.png" alt="Up arrow" width="12"></button>
                              <button class="unit-decrement-button"><img src="images/icons/dropdown_arrow.png" alt="Down arrow" width="12"></button><br>
                            </div>
                            <button class="unit-add-button carousel">Add</button>
                          </div>
                          <a class="btn btn-primary btn-custombasket btn-custombasket-carousel"><img src="images/icons/custombasket.png" alt="Basket" width="40"></a>
                          <div class="store-unit-dropdown store-unit-dropdown-custombasket">
                            <div class="unit-selection-box">
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
                    <span hidden class="product-id">${product.id}</span>
                    <img class="product-img" src="${product.image}" alt="Product">
                    <div class="product-details">
                      <h5 class="product-name">${product.name}</h5>
                      <h5 class="product-price">$${product.price}</h5>
                    </div>
                    <div class="product-buttons">
                      <a class="btn btn-primary btn-basket"><img src="images/icons/basket.png" alt="Basket" width="25">
                      </a>
                      <a class="btn btn-primary btn-custombasket"><img src="images/icons/custombasket.png" alt="Basket" width="25"></a>
                      <div class="store-unit-dropdown store-unit-dropdown-basket">
                        <div class="unit-selection-box">
                          <span class="unit-count">1</span>
                          <button class="unit-increment-button"><img src="images/icons/dropdown_arrow.png" alt="Up arrow" width="12"></button>
                          <button class="unit-decrement-button"><img src="images/icons/dropdown_arrow.png" alt="Down arrow" width="12"></button><br>
                        </div>
                        <button class="unit-add-button">Add</button>
                      </div>
                      <div class="store-unit-dropdown store-unit-dropdown-custombasket">
                        <div class="unit-selection-box">
                          <span class="unit-count">1</span>
                          <button class="unit-increment-button"><img src="images/icons/dropdown_arrow.png" alt="Up arrow" width="12"></button>
                          <button class="unit-decrement-button"><img src="images/icons/dropdown_arrow.png" alt="Down arrow" width="12"></button><br>
                        </div>
                        <button class="unit-add-button">Add</button>
                      </div>
                    </div>
                    <c:if test="${not empty product.pairedProduct.name}">
                      <h5 class="product-pairing">paired with <span class="paired-product">${product.pairedProduct.name}</span></h5>
                    </c:if>
                  </div>
                </c:forEach>
              </div>
            </div>

            <!-- Baskets -->
            <div id="baskets-container">
              <jsp:include page="basket.jsp">
                <jsp:param name="visibility" value="soft-enabled" />
                <jsp:param name="type" value="basket" />
                <jsp:param name="name" value="Basket" />
              </jsp:include>

              <jsp:include page="basket.jsp">
                <jsp:param name="visibility" value="soft-disabled" />
                <jsp:param name="type" value="custom-basket" />
                <jsp:param name="name" value="Custom Basket" />
              </jsp:include>
            </div>

          </body>

        </html>