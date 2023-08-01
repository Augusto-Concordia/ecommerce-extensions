package com.jtspringproject.JtSpringProject.controller;

import java.sql.*;
import java.util.List;
import java.util.NoSuchElementException;

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

	/*
	 * get to get data from db ( @GetMapping )
	 * post to post data to db ( @PostMapping )
	 * @RequestParam("dbcolumn") what are we gonna ask the db for ? example line 124 we are requesting the product db so we can add a new product
	 * within the getmapping the ModelAndView mv = new ModelAndView("namejsp"); namejsp should match a jsp file
	 * @...("/loginvalidate") the url directory where its gonna go
	 * return "redirect:/index"; will recall the mapping for index
	 */

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
	@GetMapping("products")
	public ModelAndView getproduct() {
		ModelAndView mView = new ModelAndView("products"); // Preparing the view to be used

		List<Product> products = this.productService.getProducts(); // preparing a list of products to insert in the view

		if (products.isEmpty()) {
			mView.addObject("msg", "No products are available");
		} else {
			mView.addObject("products", products); // view objcet "products" to be used in products.jsp
		}
		return mView;

	}
	
	@GetMapping("products/add")
	public ModelAndView addProduct() {
		ModelAndView mView = new ModelAndView("productsAdd");

		// limits the paired product to available products
		List<Product> products = this.productService.getProducts();
		mView.addObject("availableProducts", products);

		return mView;
	}

	@RequestMapping(value = "products/add",method=RequestMethod.POST)
	public String addProduct(@RequestParam("name") String name ,
							 @RequestParam("productImage") String image,
							 @RequestParam("quantity")int quantity,
							 @RequestParam("price") int price) {
		Product product = new Product();
		product.setImage(image);
		product.setName(name);
		product.setQuantity(quantity);
		product.setPrice(price);
		this.productService.addProduct(product);

		return "redirect:/admin/products";
	}

	@GetMapping("products/update/{id}")
	public ModelAndView updateproduct(@PathVariable("id") int id) {

		ModelAndView mView = new ModelAndView("productsUpdate");
		Product product = this.productService.getProduct(id);
		mView.addObject("product", product);
     	// add all products to select for paired items
     	List<Product> products = this.productService.getProducts();
    	mView.addObject("availableProducts",products);

		return mView;
		//return "redirect:/admin/coupons";
	}

	@RequestMapping(value = "products/update/{id}",method=RequestMethod.POST)
	public String updateProduct(@PathVariable("id") int id, // get the id from the path variable
								@RequestParam("name") String name ,
								@RequestParam("productImage") String image,
								@RequestParam("quantity")int quantity,
								@RequestParam("price") int price,
								@RequestParam("pairedID") int pairedID )
	{
		// transfer the pariedID posted from productsUpdate input to a Product object => to be used as an argument below
		Product pairedProduct = new Product();
		if (pairedID == 0){
			pairedProduct = null;
		}

		pairedProduct = this.productService.getProduct(pairedID);

		// Get the existing product from the database using the provided id
		Product product = this.productService.getProduct(id);
		if (product == null) {
			// Handle the case where no product with the given id exists
			throw new NoSuchElementException("No product with id " + id + " exists");
		}

		// Update the product properties
		product.setImage(image);
		product.setName(name);
		product.setQuantity(quantity);
		product.setPrice(price);
		product.setPairedProduct(pairedProduct);

		// Save the updated product back to the database
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

	@GetMapping("coupons")
	public ModelAndView getCoupons() {

		ModelAndView mView = new ModelAndView("coupons");
		List<Coupon> coupons = this.couponService.getCoupons();

		if (coupons.isEmpty()) {
			mView.addObject("msg", "No products are available");
		} else {
			mView.addObject("coupons", coupons);
		}
		return mView;


	}


}

