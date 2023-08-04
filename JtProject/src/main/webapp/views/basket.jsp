<%@page import="java.util.*" %>
    <%@page import="com.jtspringproject.JtSpringProject.models.*" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <% 
                    List<BasketProduct> products_in_r_basket = (List<BasketProduct>) request.getAttribute("products_in_regular_basket");

                    float basketSubtotalRegular = 0.0f;
                    float couponDiscountRegular = 0.0f;
                    float basketTotalRegular = 0.0f;

                    // total in basket should be calculated first
                    if (products_in_r_basket != null) {
                        for (BasketProduct basket_item : products_in_r_basket) {
                            basketSubtotalRegular += basket_item.getProduct().getPrice() * basket_item.getQuantity();
                        }

                    //---------Coupon related code -------------------
                    List<Coupon> coupons = (List<Coupon>) request.getAttribute("coupons");
                    // keeps the coupons belonging to a specific user id
                    User user = (User) request.getAttribute("user");
                    int user_id = user.getId();
                    List<Coupon> couponsForUser = new ArrayList<Coupon>();
                    for (Coupon coupon : coupons) {
                        if (coupon.getUser().getId() == user_id) {
                            couponsForUser.add(coupon);
                        }
                    }

                    // get the size of the coupons List
                    int coupons_available = couponsForUser.size();
                    int coupons_will_be_used = 0;

                    // check how many coupons can be applied to the basket
                    int coupon_needed = (int) (basketSubtotalRegular / 5);
                    // check if the user have enough coupons to apply
                    if (coupons_available > coupon_needed) {
                        // if enough, then set the coupon discount to the coupon needed
                        couponDiscountRegular = coupon_needed * 5;
                        coupons_will_be_used = coupon_needed;
                        // have to remove the coupons that the user used
                        int couponsToRemove = coupons.size() - coupon_needed;
                        List <Integer> couponsToRemoveIds = new ArrayList<Integer>();
                        for (int i = 0; i < couponsToRemove; i++) {
                            // get the id of the coupons to remove
                            int coupon_id = coupons.get(i).getId();
                            couponsToRemoveIds.add(coupon_id);
                        }
                        // After checkout
                        // post the couponsToRemoveIds to remove the coupons from the DB
                    } else {
                        // if not enough, then set the coupon discount to the coupon available
                        couponDiscountRegular = coupons_available * 5;
                        coupons_will_be_used = coupons_available;
                    }

                    // calculate how many coupon earnt and how much away to earn the next five dollar
                    int couponsEarned = (int) (basketSubtotalRegular / 100);
                    int remainder = (int) (basketSubtotalRegular % 100);
                    int amountNeeded = 100 - remainder;

                    // ---------Coupon related END---------------------------------------




                        basketTotalRegular = basketSubtotalRegular - couponDiscountRegular;
                        request.setAttribute("basketSubtotalRegularBasket", basketSubtotalRegular);
                        request.setAttribute("couponDiscountRegularBasket", couponDiscountRegular);
                        request.setAttribute("basketTotalRegularBasket", basketTotalRegular);
                        request.setAttribute("amountNeeded", amountNeeded);
                        request.setAttribute("couponsEarned", couponsEarned);
                        request.setAttribute("couponsAvailable", coupons_available);
                        request.setAttribute("couponsWillBeUsed", coupons_will_be_used);
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
                                    $(".basket #overlay").removeClass("soft-disabled");
                                    $(".basket #overlay").addClass("soft-enabled");
                                });

                                // Sets the basket overlay close trigger event handler
                                $(".basket #overlay").on("basketOverlayClose", function () {
                                    $(".basket #overlay").removeClass("soft-enabled");
                                    $(".basket #overlay").addClass("soft-disabled");
                                });
                            });
                        </script>

                        <div id="${param.type}" class="basket ${param.visibility}">
                            <div id="overlay" class="soft-disabled">
                                <div id="overlay-content">
                                    <span id="title">Head's Up :)</span>
                                    <span id="content">You have earned
                                        <span id="coupon-amount" class="overlay-values">
                                            <fmt:formatNumber value="${couponsEarned}"  /> coupon(s)
                                        </span>
                                        and are <span id="amount-needed" class="overlay-values"><fmt:formatNumber value="${amountNeeded}" pattern="0.00$" /></span>
                                        away from getting a 5$ coupon on your main basket! <br/> <br/>
                                        You have <span id="coupon-available" class="overlay-values"><fmt:formatNumber value="${couponsAvailable}"/> coupons</span> available to use, and you have
                                        <span id="coupons-used" class="overlay-values"><fmt:formatNumber value="${couponsWillBeUsed}"/> coupons</span> currently applied.
                                        <span id="close-cta">(Tap to Close)</span>
                                    </span>
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
                                            <span id="basket-action">
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