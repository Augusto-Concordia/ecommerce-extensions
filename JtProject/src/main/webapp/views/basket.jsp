<%@page import="java.util.*" %>
    <%@page import="com.jtspringproject.JtSpringProject.models.*" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <% 
                    List<BasketProduct> products_in_r_basket = (List<BasketProduct>) request.getAttribute("products_in_regular_basket");

                    float basketSubtotalRegular = 0.0f;
                    float couponDiscountRegular = 0.0f;
                    float basketTotalRegular = 0.0f;
                            
                    if (products_in_r_basket != null) {
                        for (BasketProduct basket_item : products_in_r_basket) {
                            basketSubtotalRegular += basket_item.getProduct().getPrice() * basket_item.getQuantity();
                        }

                        basketTotalRegular = basketSubtotalRegular - couponDiscountRegular;
                        request.setAttribute("basketSubtotalRegularBasket", basketSubtotalRegular);
                        request.setAttribute("couponDiscountRegularBasket", couponDiscountRegular);
                        request.setAttribute("basketTotalRegularBasket", basketTotalRegular);
                    }
                    
                    List<BasketProduct> products_in_c_basket = (List<BasketProduct>) request.getAttribute("products_in_custom_basket");

                    float basketSubtotalCustom = 0.0f;
                    float couponDiscountCustom = 0.0f;
                    float basketTotalCustom = 0.0f;
                            
                    if (products_in_c_basket != null) {
                        for (BasketProduct basket_item : products_in_c_basket) {
                            basketSubtotalCustom += basket_item.getProduct().getPrice() * basket_item.getQuantity();
                        }

                        basketTotalCustom = basketSubtotalCustom - couponDiscountCustom;
                        request.setAttribute("basketSubtotalCustomBasket", basketSubtotalCustom);
                        request.setAttribute("couponDiscountCustomBasket", couponDiscountCustom);
                        request.setAttribute("basketTotalCustomBasket", basketTotalCustom);
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
                                <c:if test='${param.type == "basket"}'>
                                <c:forEach var="basket_item" items="${products_in_regular_basket}">
                                    <jsp:include page="smallProduct.jsp">
                                        <jsp:param name="id" value="${basket_item.getProduct().getId()}" />
                                        <jsp:param name="basket_type" value="${param.type}" />
                                        <jsp:param name="name" value="${basket_item.getProduct().getName()}" />
                                        <jsp:param name="image" value="${basket_item.getProduct().getImage()}" />
                                        <jsp:param name="unit_price" value="${basket_item.getProduct().getPrice()}" />
                                        <jsp:param name="qty" value="${basket_item.getQuantity()}" />
                                    </jsp:include>
                                </c:forEach>
                                </c:if>
                                <c:if test='${param.type == "custom-basket"}'>
                                    <c:forEach var="basket_item" items="${products_in_custom_basket}">
                                        <jsp:include page="smallProduct.jsp">
                                            <jsp:param name="id" value="${basket_item.getProduct().getId()}" />
                                            <jsp:param name="basket_type" value="${param.type}" />
                                            <jsp:param name="name" value="${basket_item.getProduct().getName()}" />
                                            <jsp:param name="image" value="${basket_item.getProduct().getImage()}" />
                                            <jsp:param name="unit_price" value="${basket_item.getProduct().getPrice()}" />
                                            <jsp:param name="qty" value="${basket_item.getQuantity()}" />
                                        </jsp:include>
                                    </c:forEach>
                                </c:if>
                            </div>

                            <div id="basket-summary">
                                <div id="sub-total" class="spanning-row">
                                    <span>Sub-total</span> <span class="amount">
                                        <c:if test='${param.type == "basket"}'>
                                            <fmt:formatNumber value="${basketSubtotalRegularBasket}" pattern="0.00$" />
                                        </c:if>
                                        <c:if test='${param.type == "custom-basket"}'>
                                            <fmt:formatNumber value="${basketSubtotalCustomBasket}" pattern="0.00$" />
                                        </c:if>
                                    </span>
                                </div>

                                <div id="coupons" class="spanning-row">
                                    <c:if test='${param.type == "basket"}'>
                                        <span>Coupons</span> <span class="amount">
                                            <fmt:formatNumber value="${couponDiscountRegularBasket}" pattern="-0.00$" />
                                        </span>
                                    </c:if>
                                </div>

                                <div id="total" class="spanning-row">
                                    <span>Total</span> <span class="amount">
                                        <c:if test='${param.type == "basket"}'>
                                            <fmt:formatNumber value="${basketTotalRegularBasket}" pattern="0.00$" />
                                        </c:if>
                                        <c:if test='${param.type == "custom-basket"}'>
                                            <fmt:formatNumber value="${basketTotalCustomBasket}" pattern="0.00$" />
                                        </c:if>
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