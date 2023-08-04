<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import ="java.io.FileOutputStream" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="com.jtspringproject.JtSpringProject.models.*" %>

<%@page import=" java.io.ObjectOutputStream" %>
<%@ page import="org.springframework.boot.autoconfigure.kafka.KafkaProperties" %>
<%
    List<BasketProduct> orders = (List<BasketProduct>) request.getAttribute("orders");

    // Logic to get the paired item

    // seperate the table to 6 baskets, Get a product array for each basket
    ArrayList<ArrayList<Integer>> arrayListData = new ArrayList<>();

    // Add elements to the array
    for (int i = 1; i <= 6; i++) {  // should use a function to find how many baskets are there
        ArrayList<Integer> row = new ArrayList<>();
        arrayListData.add(row);
    }

    for (int i = 0; i < orders.size(); i++) {
        BasketProduct basketProduct = orders.get(i);
        int basketId = basketProduct.getBasket().getBasketId();
        int productId = basketProduct.getProduct().getId();
        arrayListData.get(basketId-1).add(productId);
    }

    // sort and Display the array
    System.out.println("-----------Display each basket's product array---------");
    for (int i = 0; i < arrayListData.size(); i++) {
        ArrayList<Integer> row = arrayListData.get(i);
        Collections.sort(row);
        System.out.print("Basket " + (i+1) + ": ");
        for (int j = 0; j < row.size(); j++) {
            System.out.print(row.get(j) + " ");
        }
        System.out.println();
    }


    Map<List<Integer>, Integer> pairs2 = new HashMap<>();
    for (int i = 0; i < arrayListData.size(); i++) {
        ArrayList<Integer> row = arrayListData.get(i);
        for (int j = 0; j < row.size(); j++) {
            for (int k = j+1; k < row.size() ; k++) {
                    ArrayList<Integer> pair = new ArrayList<>(); // the key
                    pair.add(row.get(j));
                    pair.add(row.get(k));
                    pairs2.put(pair, pairs2.getOrDefault(pair, 0) + 1);
            }
        }
    }

    // Print the pairs and their occurrences
    System.out.println("--------------------");
    for (Map.Entry<List<Integer>, Integer> entry : pairs2.entrySet()) {
        List<Integer> pair = entry.getKey();
        int count = entry.getValue();
        System.out.println("Pair: " + pair + ", Pairedfrequency: " + count);
    }

    System.out.println("--------------------");
    // find the max occurrences and store it in a int array
    int[] recPairedIDArr = new int[9];
    for (int i = 1; i <= 9; i++){ // we have 9 productID
        int maxOccurrences = Integer.MIN_VALUE;
        List<Integer> maxKey = null;
        int otherNumber = 0;

        for (Map.Entry<List<Integer>, Integer> entry : pairs2.entrySet()) {
            List<Integer> key = entry.getKey();
            int occurrences = entry.getValue();

            if (key.contains(i) && occurrences > maxOccurrences) {
                maxOccurrences = occurrences;
                maxKey = key;
            }
        }

        if (maxKey != null) {

            System.out.print("Target: " + i);
            otherNumber = maxKey.get(0) == i ? maxKey.get(1) : maxKey.get(0);
            System.out.print("\tPaired_Product_ID: " + otherNumber);
            //System.out.println("Key: " + maxKey);
            double pairedFrequency = (double) maxOccurrences/6* 100; // there is 6 baskets
            System.out.printf("\tPaired fequency %.0f%%\t", pairedFrequency);
            // check if the frequency is greater than 80%
            if (pairedFrequency > 80) {
                System.out.println("\tPaired item for product ID " + i + " is " + otherNumber);
                //save the otherNumber to recPairedIDArr
                recPairedIDArr[i-1] = otherNumber;
            }
            else{
                System.out.println("");
                recPairedIDArr[i-1] = 0;
            }


        } else
            System.out.println("No paired item for product ID " + i + "");
    }


    // convert the array to a to post in the HTML form
    String result = "";

    for (int i = 0; i < recPairedIDArr.length; i++) {
        if (i > 0) {
            result += ",";
        }
        result += recPairedIDArr[i];
    }
    System.out.print(result);


    // variables to use in the view
    request.setAttribute("orders", orders);
    request.setAttribute("pairedRecArr", result);
%>
<!doctype html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet"
          href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
          crossorigin="anonymous">

    <title>Document</title>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#"> <img
                th:src="@{/images/logo.png}" src="../static/images/logo.png"
                width="auto" height="40" class="d-inline-block align-top" alt="" />
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav mr-auto"></ul>
            <ul class="navbar-nav">
                <li class="nav-item active"><a class="nav-link" href="/adminhome">Home
                    Page</a></li>
                <li class="nav-item active"><a class="nav-link" href="/logout">Logout</a>
                </li>

            </ul>

        </div>
    </div>
</nav><br>
<div class="container-fluid">
    <form action="/admin/products" method="post">
        <input type="hidden" name="pairedRecArr" value="${pairedRecArr}" />
<%--        <input type="hidden" th:each="value : ${pairedRecArr}" th:name="pairedRecArr" th:value="${value}" />--%>
        <button type="submit">Send Array TO /admin/products</button>
    </form>

    <table class="table">

        <tr>
            <th scope="col">Order ID</th>
            <th scope="col">basket ID</th>
            <th scope="col">product ID</th>
            <th scope="col"></th>


        </tr>
        <tbody>

        <c:forEach var="order" items="${orders}">
            <tr>
                <td>
                        ${order.basket_product_id}
                </td>
                <td>
                        ${order.basket.getBasketId() }
                </td>
                <td>
                        ${order.product.name}
                </td>
                <td>

                </td>

            </tr>
        </c:forEach>

        </tbody>
    </table>

</div>



<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
        integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
        crossorigin="anonymous"></script>
<script
        src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
        integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
        crossorigin="anonymous"></script>
<script
        src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
        integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
        crossorigin="anonymous"></script>
</body>
</html>

