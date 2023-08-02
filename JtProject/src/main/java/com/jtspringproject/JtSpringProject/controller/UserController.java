package com.jtspringproject.JtSpringProject.controller;

import com.jtspringproject.JtSpringProject.models.Basket;
import com.jtspringproject.JtSpringProject.models.BasketProduct;
import com.jtspringproject.JtSpringProject.models.Coupon;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;

import java.io.Console;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
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

import com.jtspringproject.JtSpringProject.services.*;

	/*
	 * get to get data from db ( @GetMapping )
	 * post to post data to db ( @PostMapping )
	 * @RequestParam("dbcolumn") what are we gonna ask the db for ? example line 124 we are requesting the product db so we can add a new product
	 * within the getmapping the ModelAndView mv = new ModelAndView("namejsp"); namejsp should match a jsp file
	 * @...("/loginvalidate") the url directory where its gonna go
	 * return "redirect:/index"; will recall the mapping for index
	 */

@Controller
public class UserController {

	@Autowired
	private userService userService;
	@Autowired
	private productService productService;
	@Autowired
	private basketService basketService;

	@GetMapping("/register")
	public String registerUser() {
		return "register";
	}

	@GetMapping("/buy")
	public String buy() {
		return "buy";
	}

	@GetMapping("/")
	public ModelAndView mainRedirect(Model model, HttpServletRequest req) {
		Cookie[] cookies = req.getCookies();

		// If the user is logged in, redirect them to the home page
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

			if (u.getUsername() != null) {
				ModelAndView mView = new ModelAndView("index");
				List<Product> products = this.productService.getProducts();

				List<BasketProduct> products_in_regular_basket = new ArrayList<>();
				for (Basket basket : this.basketService.findAllRegularBaskets()) {
					products_in_regular_basket.addAll(basketService.findAllProductInBasketByBasketId(basket.getBasketId()));
				}
				

				List<BasketProduct> products_in_custom_basket = new ArrayList<>();
				for (Basket basket : this.basketService.findAllCustomBaskets()) {
					products_in_custom_basket.addAll(basketService.findAllProductInBasketByBasketId(basket.getBasketId()));
				}

				mView.addObject("products", products);

				mView.addObject("products_in_regular_basket", products_in_regular_basket);
				// System.out.println("regular" + products_in_regular_basket);
				mView.addObject("products_in_custom_basket", products_in_custom_basket);
				// System.out.println("custom" + products_in_custom_basket);

				mView.addObject("user", u);

				return mView;
			}
		}

		ModelAndView mView = new ModelAndView("index");
		mView.addObject("msg", "Please enter correct email and password");

		return new ModelAndView("userLogin");
	}

	@GetMapping("/userlogout")
	public ModelAndView userlogout(Model model, HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mView = new ModelAndView("redirect:/");

		res.addCookie(new Cookie("username", ""));

		return mView;
	}

	@RequestMapping(value = "userloginvalidate", method = RequestMethod.POST)
	public ModelAndView userlogin(@RequestParam("username") String username, @RequestParam("password") String pass,
			Model model, HttpServletResponse res) {

		User u = this.userService.checkLogin(username, pass);
		ModelAndView mView = new ModelAndView("redirect:/");

		if (u.getUsername() != null) {

			res.addCookie(new Cookie("username", u.getUsername()));

			// DO NOT DO THIS IN REAL LIFE
			// This is a quick hack to get the user to the next page, but it's terribly not
			// secure
			// An authentication token should be generated and stored in the database,
			// accompanied by a full authentication system
			res.addCookie(new Cookie("password", u.getPassword()));

			mView.addObject("user", u);
			List<Product> products = this.productService.getProducts();

			if (products.isEmpty()) {
				mView.addObject("msg", "No products are available");
			} else {
				mView.addObject("products", products);
			}
			return mView;

		} else {
			mView.addObject("msg", "Please enter correct email and password");
			return mView;
		}

	}

	@GetMapping("/user/products")
	public ModelAndView getproduct() {

		ModelAndView mView = new ModelAndView("uproduct");

		List<Product> products = this.productService.getProducts();

		if (products.isEmpty()) {
			mView.addObject("msg", "No products are available");
		} else {
			mView.addObject("products", products);
		}

		return mView;
	}

	@RequestMapping(value = "newuserregister", method = RequestMethod.POST)
	public String newUseRegister(@ModelAttribute User user) {

		System.out.println(user.getEmail());
		user.setRole("ROLE_NORMAL");
		this.userService.addUser(user);

		return "redirect:/";
	}

	// BASKET //}

	@RequestMapping(value = "basket/add", method=RequestMethod.POST)
	public String addProductToBasket(@RequestParam("id") int id, 
									@RequestParam("quantity")int quantity)
	{	
		// will add to custom or normal basket based on the find basket id
		// temp basket stuff - currently putting everything in basket id 1
		Basket basket = this.basketService.findBasket(1);
		// get the existing product from the database using the provided id
		Product product = this.productService.getProduct(id);
		if (product == null) {
			// Handle the case where no product with the given id exists
			throw new NoSuchElementException("No product with id " + id + " exists");
		}

		List<BasketProduct> products_in_basket = this.basketService.findAllBasketProducts(); // all basket products
		// check if item is already in basket
		for (BasketProduct basket_product : products_in_basket) {
            if (basket_product.getProduct().getId() == id) {
                basket_product.setQuantity(basket_product.getQuantity() + quantity);
				this.basketService.updateProductInBasket(basket_product);
				return "redirect:/";
            }
        }

		BasketProduct basketProduct = new BasketProduct();
		basketProduct.setBasket(basket);
		basketProduct.setProduct(product);
		basketProduct.setQuantity(quantity);
		this.basketService.addProductToBasket(basketProduct);
		return "redirect:/";
	}

	@PostMapping("/basket/removeitem")
	public void removeItemFromBasket(@RequestParam("basketProductID") int basketProductID) {
		// You're directly getting the id of the BasketProduct object to be removed.
		basketService.removeProductFromBasketPID(basketProductID);
	}

	@PostMapping("/basket/removeitembypid")
	public void removeItemFromBasketByProductId(@RequestParam("productID") int productID) {
		basketService.removeProductFromBasketPID(productID);
	}

	@PostMapping("/basket/clear")
	public void clearBasket() {
		basketService.removeAllProductsFromBasket();
	}

	/* User specific baskets.
	  public List<Basket> getUserRegularBaskets(Principal principal) {
        // Assuming that you're using Spring Security and the user's username is their unique identifier
        String username = principal.getName();
        User user = userService.findByUsername(username);
        return basketService.findRegularBasketsByUserId(user.getId());
    }

    @GetMapping("/baskets/custom")
    public List<Basket> getUserCustomBaskets(Principal principal) {
        String username = principal.getName();
        User user = userService.findByUsername(username);
        return basketService.findCustomBasketsByUserId(user.getId());
    }

	*/
	@GetMapping("/baskets/regular")
	public List<Basket> getAllRegularBaskets() {
		return basketService.findAllRegularBaskets();
	}

	@GetMapping("/baskets/custom")
	public List<Basket> getAllCustomBaskets() {
		return basketService.findAllCustomBaskets();
	}

}
