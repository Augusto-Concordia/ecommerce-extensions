<%@page import="java.util.*" %>
    <%@page import="com.jtspringproject.JtSpringProject.models.*" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <% List<BasketProduct> products_in_basket = (List<BasketProduct>) request.getAttribute("products_in_basket");

                        float basketSubtotal = 0.0f;
                        float couponDiscount = 0.0f;
                        float basketTotal = 0.0f;
                        
                        if (products_in_basket != null) {
                        for (BasketProduct basket_item : products_in_basket) {
                        basketSubtotal += basket_item.getProduct().getPrice() * basket_item.getQuantity();
                        }

                        basketTotal = basketSubtotal - couponDiscount;

                        request.setAttribute("basketSubtotal", basketSubtotal);
                        request.setAttribute("couponDiscount", couponDiscount);
                        request.setAttribute("basketTotal", basketTotal);
                        }
                        %>

                        <script lang="text/javascript">
                            $(document).ready(function () {

                                // Sets the basket overlay open trigger event handler
                                $(".basket #overlay").on("basketOverlayOpen", function () {
                                    $(".basket #overlay").removeClass("disabled");
                                    $(".basket #overlay").addClass("enabled");
                                });

                                // Sets the basket overlay close trigger event handler
                                $(".basket #overlay").on("basketOverlayClose", function () {
                                    $(".basket #overlay").removeClass("enabled");
                                    $(".basket #overlay").addClass("disabled");
                                });
                            });
                        </script>

                        <div id="${param.type}" class="basket ${param.visibility}">
                            <div id="overlay" class="disabled">
                                <div id="overlay-content">
                                    <span id="title">Head's Up :)</span>
                                    <span id="content">You are <span id="coupon-amount">
                                            <fmt:formatNumber value="${param.basketSubtotalUntilCoupon}" pattern=".00$" />
                                        </span> away from getting a 5$ coupon on your main basket!</span>
                                </div>
                            </div>

                            <div id="basket-header" class="spanning-row">
                                <span>${param.name}</span>
                                <img class="basket-type-switch btn btn-icon" src="images/icons/switch.png" alt="Switches the current displayed basket">
                            </div>
                            <div id="products-container">
                                <c:forEach var="basket_item" items="${products_in_basket}">
                                    <jsp:include page="smallProduct.jsp">
                                        <jsp:param name="id" value="${basket_item.getProduct().getId()}" />
                                        <jsp:param name="basket_type" value="${param.type}" />
                                        <jsp:param name="name" value="${basket_item.getProduct().getName()}" />
                                        <jsp:param name="image" value="${basket_item.getProduct().getImage()}" />
                                        <jsp:param name="unit_price" value="${basket_item.getProduct().getPrice()}" />
                                        <jsp:param name="qty" value="${basket_item.getQuantity()}" />
                                    </jsp:include>
                                </c:forEach>
                            </div>

                            <div id="basket-summary">
                                <div id="sub-total" class="spanning-row">
                                    <span>Sub-total</span> <span class="amount">
                                        <fmt:formatNumber value="${basketSubtotal}" pattern="0.00$" />
                                    </span>
                                </div>

                                <div id="coupons" class="spanning-row">
                                    <span>Coupons</span> <span class="amount">
                                        <fmt:formatNumber value="${couponDiscount}" pattern="-0.00$" />
                                    </span>
                                </div>

                                <div id="total" class="spanning-row">
                                    <span>Total</span> <span class="amount">
                                        <fmt:formatNumber value="${basketTotal}" pattern="0.00$" />
                                    </span>
                                </div>

                                <div id="actions" class="btn-container spanning-row">
                                    <div class="btn-container">
                                        <a class="btn btn-primary">
                                            <span>
                                                <c:choose>
                                                    <c:when test="${param.type == 'basket'}">
                                                        <c:out value="Checkout" />
                                                    </c:when>
                                                    <c:when test="${param.type == 'custom-basket'}">
                                                        <c:out value="Export" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:out value="Error" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </a>
                                    </div>

                                    <img class="btn btn-icon" id="remove-all" src="images/icons/delete.png" alt="Empty this basket button">
                                </div>
                            </div>
                        </div>