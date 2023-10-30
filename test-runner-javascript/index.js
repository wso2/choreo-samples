const assert = require("assert");
const axios = require("axios");

function performAPICallAndAssert(postID, callback) {
  // Make an HTTP GET request to a public API.
  axios
    .get(`https://jsonplaceholder.typicode.com/posts/${postID}`)
    .then((response) => {
      // Perform assertions on the API response data.
      const data = response.data;
      assert.strictEqual(data.userId, 1, "Expected userID to be 1");
      assert.strictEqual(data.id, postID, `Expected post ID to be ${postID}`);
      assert.strictEqual(
        data.title,
        "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "Expected title to match"
      );
      callback();
    })
    .catch((error) => {
      throw error;
    });
}

describe("API Tests", function () {
  it("Test 1: Ensure the API response matches the expected values", function (done) {
    performAPICallAndAssert(1, done);
  });

  // Add more test cases as needed.
});
