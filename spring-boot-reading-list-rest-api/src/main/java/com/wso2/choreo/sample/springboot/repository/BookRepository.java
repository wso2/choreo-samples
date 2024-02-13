package com.wso2.choreo.sample.springboot.repository;

import com.wso2.choreo.sample.springboot.model.Book;
import org.springframework.stereotype.Repository;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Repository
public class BookRepository {
    private Map<Integer, Book> map = new ConcurrentHashMap<>();

    public BookRepository() {
        map.put(1, new Book(1, "Gulliver's Travels", "Jonathan Swift", "READING"));
        map.put(2, new Book(2, "Oliver Twist", "Charles Dickens", "READING"));
    }

    public Map<Integer, Book> getAllBooks() {
        return map;
    }

    public Book findById(int id) {
        return map.get(id);
    }

    public Book save(Book book) {
        Book copy = new Book(book.id(), book.title(), book.author(), book.status());
        map.put(book.id(), copy);
        return copy;
    }

    public void delete(Integer id) {
        map.remove(id);
    }

    public Book update(Book book) {
        Book copy = new Book(book.id(), book.title(), book.author(), book.status());
        map.put(book.id(), copy);
        return copy;
    }
}
