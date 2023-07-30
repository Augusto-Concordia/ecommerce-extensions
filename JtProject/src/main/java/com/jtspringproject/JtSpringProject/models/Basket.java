
package com.jtspringproject.JtSpringProject.models;



import javax.persistence.*;

public class Basket {
    @ManyToOne
    @JoinColumn(name = "customer_id")
    private User user;

    private String basket_type;

    private String basket_items;

    public User getUser() { // return a User object with all the information about the customer
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getBasketType() {
        return basket_type;
    }

    public void setBasketType(String basket_type) {
        this.basket_type = basket_type;
    }


}
