package com.jtspringproject.JtSpringProject.models;
import javax.persistence.*;
import java.io.Serializable;

@Entity(name="BASKET_PRODUCT")
public class BasketProduct {
    // by adding @id to both , it makes the combine basket_id and product_id the primary key

    private BasketProductPK id;

    private int quantity;


    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    @Embeddable
    public static class BasketProductPK implements Serializable {

        @Column(name = "basket_id")
        private int basketId;

        @Column(name = "product_id")
        private int productId;

        public int getBasketId(){return basketId;}
        public void setBasketId(int basketId) {this.basketId = basketId;}
        public int getProductId(){return productId;}
        public void getProductId(int productId) {this.productId = productId;}
    }

}