package com.wso2.choreo.sample.springboot.service;

import com.wso2.choreo.sample.springboot.model.Book;
import com.wso2.choreo.sample.springboot.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class BookService {
    @Autowired
    private BookRepository repository;

    public Book saveBook(Book book) {
        return repository.save(book);
    }

    public Map<Integer, Book> getBooks() {
        return repository.getAllBooks();
    }

    public Book getBookById(int id) {
        return repository.findById(id);
    }

    public String deleteBook(int id) {
        repository.delete(id);
        return "Book removed !! " + id;
    }

    public Book updateBook(Book book) {
        return repository.update(book);
    }
}
