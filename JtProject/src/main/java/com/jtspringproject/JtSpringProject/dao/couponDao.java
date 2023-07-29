package com.jtspringproject.JtSpringProject.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.jtspringproject.JtSpringProject.models.Coupon;

@Repository
public class couponDao {
    @Autowired
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
        this.sessionFactory = sf;
    }


    //Method-level Transaction: Placing @Transactional on a specific method means that whenever
    // that method is called, a transaction will be initiated to encapsulate its database operations.


    @Transactional
    public List<Coupon> getCoupons() {

        return this.sessionFactory.getCurrentSession().createQuery("from COUPON").list();
    }

    @Transactional
    public Boolean deleteCoupon(int id) {

        Session session = this.sessionFactory.getCurrentSession();
        Object persistanceInstance = session.load(Coupon.class, id);

        if (persistanceInstance != null) {
            session.delete(persistanceInstance);
            return true;
        }
        return false;
    }


    @Transactional
    public Coupon getCoupon(int id) {
        return this.sessionFactory.getCurrentSession().get(Coupon.class,id);
    }
}
