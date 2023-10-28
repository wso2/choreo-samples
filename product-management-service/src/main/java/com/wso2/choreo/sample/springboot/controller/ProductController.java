package com.wso2.choreo.sample.springboot.controller;

import com.wso2.choreo.sample.springboot.model.Product;
import com.wso2.choreo.sample.springboot.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
import java.util.List;

@RestController
@RequestMapping("/products")
public class ProductController {

    @Autowired
    private ProductService service;

    @PostMapping
    public Product addProduct(@RequestBody Product product) {
        return service.saveProduct(product);
    }

    @GetMapping
    public Collection<Product> findAllProducts() {
        return service.getProducts().values();
    }

    @GetMapping("{id}")
    public Product findProductById(@PathVariable int id) {
        return service.getProductById(id);
    }

    @PutMapping
    public Product updateProduct(@RequestBody Product product) {
        return service.updateProduct(product);
    }

    @DeleteMapping("{id}")
    public String deleteProduct(@PathVariable int id) {
        return service.deleteProduct(id);
    }
}