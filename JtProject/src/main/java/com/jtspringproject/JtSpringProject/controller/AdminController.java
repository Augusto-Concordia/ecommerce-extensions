package com.jtspringproject.JtSpringProject.controller;

import java.sql.*;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.jtspringproject.JtSpringProject.models.*;
import com.jtspringproject.JtSpringProject.services.*;
import com.mysql.cj.protocol.Resultset;

import net.bytebuddy.asm.Advice.This;
import net.bytebuddy.asm.Advice.OffsetMapping.ForOrigin.Renderer.ForReturnTypeName;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private userService userService;
	@Autowired
	private productService productService;
	@Autowired
	private couponService couponService;

	@GetMapping()
	public ModelAndView mainRedirect(Model model, HttpServletRequest req) {
		Cookie[] cookies = req.getCookies();

		// If the user is logged in, redirect them to the admin page
		if (cookies != null) {
			String username = "";
			String password = "";

			for (Cookie cookie : cookies) {
				String name = cookie.getName();
				String value = cookie.getValue();

				if (name.equalsIgnoreCase("username")) {
					username = value;
				} else if (name.equalsIgnoreCase("password")) {
					password = value;
				}
			}

			User u = this.userService.checkLogin(username, password);

			if (u.getUsername() != null && u.getRole().equals("ROLE_ADMIN")) {
				ModelAndView mView = new ModelAndView("admin");

				mView.addObject("user", u);

				return mView;
			}
		}

		ModelAndView mView = new ModelAndView("admin");
		mView.addObject("msg", "Please enter correct email and password");

		return new ModelAndView("userLogin");
	}

	// PRODUCTS //
	@GetMapping("products/add")
	public ModelAndView addProduct() {
		ModelAndView mView = new ModelAndView("productsAdd");

		// limits the paired product to available products
		List<Product> products = this.productService.getProducts();
		mView.addObject("availableProducts", products);

		return mView;
	}

	@RequestMapping(value = "products/add", method = RequestMethod.POST)
	public String addProduct(@RequestParam("name") String name,
			@RequestParam("productImage") String image,
			@RequestParam("paired_product_id") int paired_product,
			@RequestParam("quantity") int quantity,
			@RequestParam("price") int price) {
		Product product = new Product();
		product.setProductValues(name, image, paired_product, quantity, price);
		this.productService.addProduct(product);

		return "redirect:/admin/products";
	}

	@GetMapping("products/update/{id}")
	public ModelAndView updateproduct(@PathVariable("id") int id) {

		ModelAndView mView = new ModelAndView("productsUpdate");
		Product product = this.productService.getProduct(id);
		// limits the paired product to available products
		List<Product> products = this.productService.getProducts();
		mView.addObject("availableProducts", products);
		mView.addObject("product", product);
		return mView;
	}

	@RequestMapping(value = "products/update/{id}", method = RequestMethod.POST)
	public String updateProduct(@RequestParam("name") String name, @RequestParam("productImage") String image,
			@RequestParam("paired_product_id") int paired_product, @RequestParam("quantity") int quantity,
			@RequestParam("price") int price) {
		Product product = new Product();
		product.setProductValues(name, image, paired_product, quantity, price);
		this.productService.updateProduct(product);
		return "redirect:/admin/products";
	}

	@GetMapping("products/delete")
	public String removeProduct(@RequestParam("id") int id) {
		this.productService.deleteProduct(id);
		return "redirect:/admin/products";
	}

	@PostMapping("products")
	public String postproduct() {
		return "redirect:/admin/products";
	}

	@RequestMapping(value = "updateuser", method = RequestMethod.POST)
	public String updateUserProfile(@RequestParam("userid") int userid, @RequestParam("username") String username,
			@RequestParam("email") String email, @RequestParam("password") String password,
			@RequestParam("address") String address)

	{
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommjava", "root", "");

			PreparedStatement pst = con
					.prepareStatement("update users set username= ?,email = ?,password= ?, address= ? where uid = ?;");
			pst.setString(1, username);
			pst.setString(2, email);
			pst.setString(3, password);
			pst.setString(4, address);
			pst.setInt(5, userid);
			int i = pst.executeUpdate();
		} catch (Exception e) {
			System.out.println("Exception:" + e);
		}
		return "redirect:/index";
	}

	@GetMapping("coupons") // this is used in jsp file and unpacked with for each function <c:forEach
							// var="product" items="${products}">
	public ModelAndView getCouponDetail() {

		ModelAndView mView = new ModelAndView("displayCoupons");
		List<Coupon> coupons = this.couponService.getCoupons();
		mView.addObject("coupons", coupons);
		return mView;

	}
}
