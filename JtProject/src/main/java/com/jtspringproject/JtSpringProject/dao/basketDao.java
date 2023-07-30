package com.jtspringproject.JtSpringProject.dao;
import com.jtspringproject.JtSpringProject.models.Basket;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
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

    /*
    @SuppressWarnings("unchecked")
    public List<Basket> findAll() {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("from basket").list();
    }
    */

}
