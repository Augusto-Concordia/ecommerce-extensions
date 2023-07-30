package com.jtspringproject.JtSpringProject.models;

import javax.persistence.*;

@Entity(name="COUPON") // name from the database Table
public class Coupon {
	@Id
	@Column(name = "coupon_id") //very likely is the primary key in the COUPON table
	@GeneratedValue(strategy= GenerationType.AUTO)
	private int id;

	// very likely is setting the foreign key

	@ManyToOne
	@JoinColumn(name = "customer_id")
	private User user;
//    @OneToOne(cascade = CascadeType.ALL)
//    @JoinColumn(name = "customer_id",referencedColumnName = "customer_id")
//    private User user; // reference to the User object in java

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public User getUser() { // return a User object with all the information about the customer
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

}