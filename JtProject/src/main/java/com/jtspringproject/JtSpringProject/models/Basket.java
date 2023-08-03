
package com.jtspringproject.JtSpringProject.models;
import javax.persistence.*;

@Entity(name="BASKET") // name from the database Table
@Table
public class Basket {
     
    @Id
    @Column(name = "basket_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int basket_id;

    @ManyToOne //(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    private User user;

    private String basket_type;

    public int getBasketId() {
		return basket_id;
	}

	public void setBasketId(int basket_id) {
		this.basket_id = basket_id;
	}

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

    @Override
	public String toString() {
		return "Basket [user=" + user.getId() + ", basket_type=" + basket_type + "]";
	}

}
