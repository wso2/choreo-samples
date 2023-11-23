package com.wso2.choreo.sample.springboot.repository;

import com.wso2.choreo.sample.springboot.model.Product;
import org.springframework.stereotype.Repository;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Repository
public class ProductRepository {
    private Map<Integer, Product> map = new ConcurrentHashMap<>();

    public ProductRepository() {
        map.put(1, new Product(1, "product 1", 10, 1000));
        map.put(2, new Product(2, "product 2", 20, 2000));
        map.put(3, new Product(3, "product 3", 30, 3000));
    }

    public Map<Integer, Product> getAllProducts() {
        return map;
    }

    public Product findById(int id) {
        return map.get(id);
    }

    public Product save(Product p) {
        Product copy = new Product(p.id(), p.name(), p.quantity(), p.price());
        map.put(p.id(), copy);
        return copy;
    }

    public void delete(Integer id) {
        map.remove(id);
    }

    public Product update(Product product) {
        Product copy = new Product(product.id(), product.name(), product.quantity(), product.price());
        map.put(product.id(), copy);
        return copy;
    }
}