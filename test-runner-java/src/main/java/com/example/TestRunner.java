package com.example;

import java.io.IOException;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class TestRunner {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();
        int postID = 1; // Change this to the post ID you want to test

        // Create an HTTP request to make an API call
        Request request = new Request.Builder()
                .url("https://jsonplaceholder.typicode.com/posts/" + postID)
                .get()
                .build();

        try {
            // Execute the request
            Response response = client.newCall(request).execute();
            String responseBody = response.body().string();

            // Perform assertions on the response
            if (response.isSuccessful()) {
                System.out.println("API call successful");
                if (response.code() == 200) {
                    System.out.println("Status code is 200");
                } else {
                    System.out.println("Status code is not 200");
                }

                // You can add more assertions based on the response body
                if (responseBody.contains("sunt aut facere repellat provident occaecati excepturi optio reprehenderit")) {
                    System.out.println("Title matches expected value");
                } else {
                    System.out.println("Title does not match expected value");
                }
            } else {
                System.out.println("API call failed");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
