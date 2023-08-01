package com.jtspringproject.JtSpringProject.services;

import com.jtspringproject.JtSpringProject.dao.basketProductDao;
import com.jtspringproject.JtSpringProject.dao.basketDao;
import com.jtspringproject.JtSpringProject.models.Basket;
import com.jtspringproject.JtSpringProject.models.BasketProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class basketService {

    private final basketDao basketDao;
    private final basketProductDao basketProductDao;

    @Autowired
    public basketService(basketDao basketDao, basketProductDao basketProductDao) {
        this.basketDao = basketDao;
        this.basketProductDao = basketProductDao;
    }

    @Transactional
    public void addBasket(Basket basket) {
        basketDao.save(basket);
    }

    @Transactional
    public void updateBasket(Basket basket) {
        basketDao.update(basket);
    }

    @Transactional
    public void deleteBasket(int id) {
        basketDao.delete(id);
    }

    @Transactional
    public Basket findBasket(int id) {
        return basketDao.findById(id);
    }

    @Transactional
    public List<Basket> findAllBaskets() {
        return basketDao.findAll();
    }

    public List<Basket> findAllBasketsById(int user_id) {
        return basketDao.findAllBasketByUser(user_id);
    }

    // BASKET PRODUCT //

    @Transactional
    public void addProductToBasket(BasketProduct basketProduct) {
        basketProductDao.save(basketProduct);
    }

    @Transactional
    public void removeProductFromBasket(int id) {
        BasketProduct basketProduct = basketProductDao.findById(id);
        if (basketProduct != null) {
            System.out.println("\n\n\n\nBasketProduct found: " + basketProduct.toString());
            basketProductDao.delete(id);
        } else {
            System.out.println("\n\n\n\n\nBasketProduct not found for ID: " + id);
        }
    }
    //created this implementation for universal basket, we prob need to add more constraints for user
    //specific
    @Transactional
    public void removeProductFromBasketPID(int product_id) {
        BasketProduct basketProduct = basketProductDao.findByProductId(product_id);
        if (basketProduct != null) {
            basketProductDao.delete(basketProduct.getBasket_product_id());
        } else {
            System.out.println("BasketProduct why not not found for Product ID: " + product_id);
        }
    }

    @Transactional
    public void updateProductInBasket(BasketProduct basketProduct) {
        basketProductDao.update(basketProduct);
    }

    @Transactional
    public BasketProduct findProductInBasket(int id) {
        return basketProductDao.findById(id);
    }

    @Transactional
    public List<BasketProduct> findAllBasketProducts() {
        return basketProductDao.findAll();
    }

    @Transactional
    public List<BasketProduct> findAllProductInBasketByBasketId(int basket_id) {
        List<BasketProduct> products_in_basket = new ArrayList();
        for (BasketProduct basket_product : basketProductDao.findAll()) {
            if (basket_product.getProduct().getId() == basket_id) {
                products_in_basket.add(basket_product);
            }
        }
        return products_in_basket;
    }

    @Transactional
    public void removeAllProductsFromBasket() {
        basketProductDao.deleteAll();
    }


}

