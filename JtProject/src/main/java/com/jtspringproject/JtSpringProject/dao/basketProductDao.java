package com.jtspringproject.JtSpringProject.dao;
import com.jtspringproject.JtSpringProject.models.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.hibernate.query.Query;

import java.util.List;

@Repository
public class basketProductDao {
    @Autowired
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
        this.sessionFactory = sf;
    }

    public void save(BasketProduct basketProduct) {
        Session session = sessionFactory.getCurrentSession();
        session.persist(basketProduct);
    }

    public void update(BasketProduct basketProduct) {
        Session session = sessionFactory.getCurrentSession();
        session.update(basketProduct);
    }


    public void delete(int id) {
        Session session = sessionFactory.getCurrentSession();
        BasketProduct basket_product = session.byId(BasketProduct.class).load(id);
        if (basket_product != null) {
            session.delete(basket_product);
        }
    }

    public BasketProduct findById(int id) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(BasketProduct.class, id);
    }

    @SuppressWarnings("unchecked")
    public List<BasketProduct> findAll() {
        return this.sessionFactory.getCurrentSession().createQuery("from BASKET_PRODUCT").list();
    }

    public void deleteAll() {
        Session session = sessionFactory.getCurrentSession();
        Query query = session.createQuery("delete from BASKET_PRODUCT");
        query.executeUpdate();
    }

    public BasketProduct findByProductId(int product_id) {
        Session session = sessionFactory.getCurrentSession();
        Query query = session.createQuery("from BASKET_PRODUCT bp where bp.product.id = :product_id");
        query.setParameter("product_id", product_id);
        List<BasketProduct> results = query.list();
        if (results.isEmpty()) {
            return null; // handle no-results scenario
        } else {
            return results.get(0); // return first matching BasketProduct
        }
    }



}
