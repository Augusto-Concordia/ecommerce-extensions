package com.jtspringproject.JtSpringProject.models;
import javax.persistence.*;
import java.io.Serializable;



@Entity(name="BASKET_PRODUCT")
@Table
public class BasketProduct {

    @Id
    @Column(name = "basket_product_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int basket_product_id;

    @ManyToOne // (fetch = FetchType.LAZY)
    @JoinColumn(name = "basket_id")
    private Basket basket;

    @ManyToOne // (fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    private int quantity;

    public Basket getBasket() {return basket;}

    public int getBasket_product_id() {
        return basket_product_id;
    }

    public void setBasket(Basket basket) {this.basket = basket;}

    public Product getProduct() {return product;}

    public void setProduct(Product product) {this.product = product;}

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }



}