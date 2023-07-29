package com.jtspringproject.JtSpringProject.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jtspringproject.JtSpringProject.dao.couponDao;
import com.jtspringproject.JtSpringProject.models.Coupon;

import net.bytebuddy.dynamic.DynamicType.Builder.InnerTypeDefinition;

@Service
public class couponService {
    @Autowired
    private couponDao couponDao;

    public List<Coupon> getCoupons(){
        return this.couponDao.getCoupons();
    }

    public Boolean deleteCoupon(int id) {
        return this.couponDao.deleteCoupon(id);
    }

    public Coupon getCoupon(int id) {
        return this.couponDao.getCoupon(id);
    }
}

