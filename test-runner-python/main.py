import requests
import pytest

# Define the API testing function
def test_api_script():
    api_url = "https://jsonplaceholder.typicode.com/posts/1"
    response = requests.get(api_url)
    
    assert response.status_code == 200, f"Expected status code 200, but got {response.status_code}"

    data = response.json()
    assert data["userId"] == 1, "User ID should be 1"
    assert data["id"] == 1, "ID should be 1"
    assert data["title"] == "sunt aut facere repellat provident occaecati excepturi optio reprehenderit", "Title does not match"

# Run the tests using pytest
if __name__ == "__main__":
    pytest.main()
