package com.wso2.choreo.sample.springboot.controller;

import com.wso2.choreo.sample.springboot.model.Book;
import com.wso2.choreo.sample.springboot.service.BookService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;

@RestController
@RequestMapping("/books")
public class BookController {

    @Autowired
    private BookService service;

    @Operation(summary = "Add a new book")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successful response",
                    content = @Content(mediaType = "application/json"))
    })
    @io.swagger.v3.oas.annotations.parameters.RequestBody(
            description = "Add a new book",
            required = true,
            content = @Content(mediaType = "application/json",
                    schema = @Schema(implementation = Book.class),
                    examples = @ExampleObject(value = "{ \"id\": 3, \"title\": \"To Kill a Mockingbird\", \"author\": \"Harper Lee\", \"status\": \"READ\" }"))
    )
    @PostMapping
    public Book addBook(@RequestBody Book book) {
        return service.saveBook(book);
    }

    @Operation(summary = "Get all books")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successful response",
                    content = @Content(mediaType = "application/json"))
    })
    @GetMapping
    public Collection<Book> findAllBooks() {
        return service.getBooks().values();
    }

    @Operation(summary = "Get book by ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successful response",
                    content = @Content(mediaType = "application/json"))
    })
    @GetMapping("/id")
    public Book findBookById(@RequestParam("id") int bookId) {
        return service.getBookById(bookId);
    }

    @Operation(summary = "Update an existing book's details")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successful response",
                    content = @Content(mediaType = "application/json"))
    })
    @io.swagger.v3.oas.annotations.parameters.RequestBody(
            description = "Update an existing book's details",
            required = true,
            content = @Content(mediaType = "application/json",
                    schema = @Schema(implementation = Book.class),
                    examples = @ExampleObject(value = "{ \"id\": 1, \"title\": \"Gulliver's Travels\", \"author\": \"Jonathan Swift\", \"status\": \"READ\" }"))
    )
    @PutMapping
    public Book updateBook(@RequestBody Book book) {
        return service.updateBook(book);
    }

    @Operation(summary = "Delete book by ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successful response",
                    content = @Content(mediaType = "application/json"))
    })
    @DeleteMapping
    public String deleteBook(@RequestParam("id") int bookId) {
        return service.deleteBook(bookId);
    }
}
