package com.jtspringproject.JtSpringProject.dao;
import com.jtspringproject.JtSpringProject.models.Basket;
import com.jtspringproject.JtSpringProject.models.BasketProduct;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class basketDao {
    @Autowired
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
        this.sessionFactory = sf;
    }

    public void save(Basket basket) {
        Session session = sessionFactory.getCurrentSession();
        session.persist(basket);
    }

    public void update(Basket basket) {
        Session session = sessionFactory.getCurrentSession();
        session.update(basket);
    }

    public void delete(int id) {
        Session session = sessionFactory.getCurrentSession();
        Basket basket = session.get(Basket.class, id);
        if (basket != null) {
            session.delete(basket);
        }
    }

    public Basket findById(int id) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(Basket.class, id);
    }

    @SuppressWarnings("unchecked")
    public List<Basket> findAll() {
        return this.sessionFactory.getCurrentSession().createQuery("from BASKET").list();
    }

    @SuppressWarnings("unchecked")
    public List<Basket> findAllBasketByUser(int user_id) {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("from BASKET where user_id = :user_id").list();
    }

    @SuppressWarnings("unchecked")
    public Basket findAllBasketByUserNType(int customer_id, String basket_type) {
        Session session = sessionFactory.getCurrentSession();
        Query query = session.createQuery("from BASKET where customer_id = :customer_id AND basket_type =:basket_type");
        query.setParameter("customer_id", customer_id);
        query.setParameter("basket_type", basket_type);
        List<Basket> results = query.list();
        if (results.isEmpty()) {
            return null; // handle no-results scenario
        } else {
            return results.get(0); // return first matching BasketProduct
        }
    }

}
