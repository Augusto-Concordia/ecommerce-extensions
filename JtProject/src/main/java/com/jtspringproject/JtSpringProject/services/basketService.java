package com.jtspringproject.JtSpringProject.services;

import com.jtspringproject.JtSpringProject.dao.basketProductDao;
import com.jtspringproject.JtSpringProject.dao.basketDao;
import com.jtspringproject.JtSpringProject.models.Basket;
import com.jtspringproject.JtSpringProject.models.BasketProduct;
import com.jtspringproject.JtSpringProject.models.Coupon;
import com.jtspringproject.JtSpringProject.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import java.util.Map;
import java.util.HashMap;

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
    public void removeProductFromBasket(int user_id, int product_id) {
        Basket basket = basketDao.findAllBasketByUserNType(user_id, "BASKET");
        List<BasketProduct> basket_products = findAllProductInBasketByBasketId(basket.getBasketId());

        for (BasketProduct product : basket_products) {
            if (product.getProduct().getId() == product_id) {
                basketProductDao.delete(product.getBasket_product_id());
                break;
            }
        }
    }

    @Transactional
    public void removeProductFromCustomBasket(int user_id, int product_id) {
        Basket basket = basketDao.findAllBasketByUserNType(user_id, "CUSTOM_BASKET");
        List<BasketProduct> basket_products = findAllProductInBasketByBasketId(basket.getBasketId());

        for (BasketProduct product : basket_products) {
            if (product.getProduct().getId() == product_id) {
                basketProductDao.delete(product.getBasket_product_id());
                break;
            }
        }
    }

    @Transactional
    public void updateProductInBasket(BasketProduct basketProduct) {
        basketProductDao.update(basketProduct);
    }

    @Transactional
    public List<BasketProduct> findAllProductInBasketByBasketId(int basket_id) {
        List<BasketProduct> allBasketsProducts = basketProductDao.findAll();
        return allBasketsProducts.stream()
                .filter(basketproduct -> basket_id == (basketproduct.getBasket().getBasketId()))
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteBasketProduct(int id) {
        basketProductDao.delete(id);
    }

    @Transactional
    public void clearBasketForUser(int user_id, String basket_type) {
        Basket basket = getUserBasker(user_id, basket_type);
        List<BasketProduct> allProducts = findAllProductInBasketByBasketId(basket.getBasketId());
        for (BasketProduct product : allProducts) {
            basketProductDao.delete(product.getBasket_product_id());
        }
    }

    @Transactional
    public List<Basket> findAllRegularBaskets() {
        List<Basket> allBaskets = basketDao.findAll();
        return allBaskets.stream()
                .filter(basket -> "BASKET".equals(basket.getBasketType()))
                .collect(Collectors.toList());
    }

    @Transactional
    public List<Basket> findAllCustomBaskets() {
        List<Basket> allBaskets = basketDao.findAll();
        return allBaskets.stream()
                .filter(basket -> "CUSTOM_BASKET".equals(basket.getBasketType()))
                .collect(Collectors.toList());
    }

    @Transactional
    public void combineBaskets(Basket c_basket, Basket r_basket) {
        List<BasketProduct> custom_basket_products = findAllProductInBasketByBasketId(c_basket.getBasketId());
        List<BasketProduct> regular_basket_products = findAllProductInBasketByBasketId(r_basket.getBasketId());
        boolean found = false;

        for (BasketProduct c_product : custom_basket_products) {
            int productId = c_product.getProduct().getId();
            int newQuantity = c_product.getQuantity();
            found = false;
            for (BasketProduct r_product : regular_basket_products) {
                if (r_product.getProduct().getId() == productId) {
                    r_product.setQuantity( r_product.getQuantity() + newQuantity );
                    updateProductInBasket(r_product);
                    found = true;
                    break;
                }
            }
            if (found == false) {
                // if custom product not already in regular basket
                BasketProduct new_product = new BasketProduct();   
                new_product.setBasket(r_basket);
                new_product.setProduct(c_product.getProduct());
                new_product.setQuantity(newQuantity);       
                addProductToBasket(new_product);
            }
        }
    }

    @Transactional
    public Basket getUserBasker(int user_id, String basket_type) {
        return basketDao.findAllBasketByUserNType(user_id, basket_type);
    }

    @Transactional
    public void addCustomBasketToBasket(int user_id) {
        // get custom
        Basket custom_basket = basketDao.findAllBasketByUserNType(user_id, "CUSTOM_BASKET");
        // get regular
        Basket basket = basketDao.findAllBasketByUserNType(user_id, "BASKET");

        combineBaskets(custom_basket, basket);
    }

    @Transactional
    public void emptyCustomerBasket(int user_id) {
        Basket basket = basketDao.findAllBasketByUserNType(user_id, "BASKET");
        List<BasketProduct> basket_products = findAllProductInBasketByBasketId(basket.getBasketId());

        for (BasketProduct product : basket_products) {
            basketProductDao.delete(product.getBasket_product_id());
        }

    }

    @Transactional
    public void giveUserBaskets(User u) {
        List<Basket> user_baskets = findAllBasketsById(u.getId());
        if (user_baskets.isEmpty()) {
            Basket new_basket = new Basket();   
            new_basket.setUser(u); 
            new_basket.setBasketType("BASKET");      
            addBasket(new_basket);

            Basket new_custombasket = new Basket();   
            new_custombasket.setUser(u); 
            new_custombasket.setBasketType("CUSTOM_BASKET");      
            addBasket(new_custombasket);
        }
        else {
            List<Basket> custombasket = user_baskets.stream()
                .filter(c -> "CUSTOM_BASKET".equals(c.getBasketType()))
                .collect(Collectors.toList());

            List<Basket> basket = user_baskets.stream()
                .filter(b -> "BASKET".equals(b.getBasketType()))
                .collect(Collectors.toList());

            if (custombasket.isEmpty()) {
                Basket new_custombasket = new Basket();   
                new_custombasket.setUser(u); 
                new_custombasket.setBasketType("CUSTOM_BASKET");      
                addBasket(new_custombasket);
            }
            if (basket.isEmpty()) {
                Basket new_basket = new Basket();   
                new_basket.setUser(u); 
                new_basket.setBasketType("BASKET");      
                addBasket(new_basket);
            }
        }
    }

}




