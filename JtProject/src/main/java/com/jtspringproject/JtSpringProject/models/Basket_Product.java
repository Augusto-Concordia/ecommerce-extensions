package com.jtspringproject.JtSpringProject.models;
import javax.persistence.*;

public class Basket_Product {
    // by adding @id to both , it makes the combine basket_id and product_id the primary key
    
    @Id
    @ManyToOne
    @JoinColumn(name = "basket_id")
    private Basket basket;

    @Id
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    private int quantity;

    public Basket getBasket() {
		return basket;
	}

	public void setBasket(Basket basket) {
		this.basket = basket;
	}

    public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
