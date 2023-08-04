package com.jtspringproject.JtSpringProject.services;

import com.jtspringproject.JtSpringProject.dao.basketProductDao;
import com.jtspringproject.JtSpringProject.models.BasketProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class basketProductService {
    @Autowired
    private basketProductDao basketProductDao;


    public List<BasketProduct> getOrders(){
        return this.basketProductDao.findAll();
    }
}

