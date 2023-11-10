package com.wso2.choreo.sample.springboot;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wso2.choreo.sample.springboot.model.Product;
import com.wso2.choreo.sample.springboot.service.ProductService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import java.util.Collection;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class ProductCatalogApplicationTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ProductService productService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void testAddProduct() throws Exception {
        Product product = new Product(4, "Test product", 10, 200);

        mockMvc.perform(MockMvcRequestBuilders
                .post("/products")
                .content(objectMapper.writeValueAsString(product))
                .contentType(MediaType.APPLICATION_JSON)
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        Collection<Product> products = productService.getProducts().values();
        assertEquals(4, products.size());
    }

    @Test
    void testFindAllProducts() throws Exception {

        MvcResult result = mockMvc.perform(MockMvcRequestBuilders
                .get("/products")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andReturn();

        String responseBody = result.getResponse().getContentAsString();
        Collection<Product> products = objectMapper.readValue(responseBody, new TypeReference<Collection<Product>>() {});

        assertEquals(4, products.size());
    }

    @Test
    void testFindProductById() throws Exception {
        Product product = new Product(4, "Test product", 10, 200);
        Product savedProduct = productService.saveProduct(product);

        MvcResult result = mockMvc.perform(MockMvcRequestBuilders
                .get("/products/{id}", savedProduct.id())
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andReturn();

        String responseBody = result.getResponse().getContentAsString();
        Product retrievedProduct = objectMapper.readValue(responseBody, Product.class);

        assertEquals(savedProduct.id(), retrievedProduct.id());
        assertEquals(savedProduct.name(), retrievedProduct.name());
        assertEquals(savedProduct.price(), retrievedProduct.price());
    }
}

