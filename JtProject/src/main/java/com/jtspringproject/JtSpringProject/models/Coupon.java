package com.jtspringproject.JtSpringProject.models;

import javax.persistence.*;

@Entity(name="COUPON") // name from the database Table
@Table
public class Coupon {

	@Id
	@Column(name = "coupon_id")
	@GeneratedValue(strategy= GenerationType.IDENTITY)
	private int id;

	@ManyToOne //(fetch = FetchType.LAZY)
	@JoinColumn(name = "customer_id")
	private User user;

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