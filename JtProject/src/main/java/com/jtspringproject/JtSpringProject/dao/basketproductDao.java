package com.jtspringproject.JtSpringProject.dao;
import com.jtspringproject.JtSpringProject.models.*;
import com.jtspringproject.JtSpringProject.models.BasketProduct.BasketProductPK;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import javax.persistence.*;
import java.io.Serializable;

import java.util.List;

@Repository
public class basketproductDao {

    @Autowired
    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sf) {
        this.sessionFactory = sf;
    }

    @EmbeddedId
    private BasketProductPK bpk;

    private int quantity;




    public void save(BasketProduct basketProduct) {
        Session session = sessionFactory.getCurrentSession();
        session.persist(basketProduct);
    }

    public void update(BasketProduct basketProduct) {
        Session session = sessionFactory.getCurrentSession();
        session.update(basketProduct);
    }


    public void delete(BasketProduct.BasketProductPK id) {
        Session session = sessionFactory.getCurrentSession();
        BasketProduct basketProduct = findById(id);
        if (basketProduct != null) {
            session.delete(basketProduct);
        }
    }

    public BasketProduct findById(BasketProduct.BasketProductPK id) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(BasketProduct.class, id);
    }
    /*

    @SuppressWarnings("unchecked")
    public List<BasketProduct> findAll() {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("from BasketProduct").list();
    }

     */

}
