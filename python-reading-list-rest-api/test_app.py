import unittest
import json
from app import app

class TestReadingListApp(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()
        self.books = []

    def test_get_empty_book_list(self):
        response = self.app.get('/reading-list/books')
        data = json.loads(response.get_data(as_text=True))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['books'], [])

    def test_add_book(self):
        new_book = {
            'author': 'John Doe',
            'name': 'Sample Book',
            'status': 'unread'
        }
        response = self.app.post('/reading-list/books', json=new_book)
        data = json.loads(response.get_data(as_text=True))
        self.assertEqual(response.status_code, 200)
        self.assertIn('id', data)
        self.assertEqual(data['author'], new_book['author'])
        self.assertEqual(data['name'], new_book['name'])
        self.assertEqual(data['status'], new_book['status'])
        self.books.append(data)

    def test_get_single_book(self):
        new_book = {
            'author': 'Jane Smith',
            'name': 'Another Book',
            'status': 'read'
        }
        response = self.app.post('/reading-list/books', json=new_book)
        data = json.loads(response.get_data(as_text=True))
        book_id = data['id']

        response = self.app.get(f'/reading-list/books/{book_id}')
        data = json.loads(response.get_data(as_text=True))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['id'], book_id)
        self.assertEqual(data['author'], new_book['author'])
        self.assertEqual(data['name'], new_book['name'])
        self.assertEqual(data['status'], new_book['status'])

    def test_delete_book(self):
        new_book = {
            'author': 'Mark Johnson',
            'name': 'Yet Another Book',
            'status': 'in-progress'
        }
        response = self.app.post('/reading-list/books', json=new_book)
        data = json.loads(response.get_data(as_text=True))
        book_id = data['id']

        response = self.app.delete(f'/reading-list/books/{book_id}')
        self.assertEqual(response.status_code, 204)

        response = self.app.get(f'/reading-list/books/{book_id}')
        self.assertEqual(response.status_code, 404)

    def test_update_book_status(self):
        new_book = {
            'author': 'Sara Lee',
            'name': 'Cookbook',
            'status': 'unread'
        }
        response = self.app.post('/reading-list/books', json=new_book)
        data = json.loads(response.get_data(as_text=True))
        book_id = data['id']

        updated_status = 'in-progress'
        update_data = {'status': updated_status}

        response = self.app.put(f'/reading-list/books/{book_id}', json=update_data)
        data = json.loads(response.get_data(as_text=True))

        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['id'], book_id)
        self.assertEqual(data['status'], updated_status)

    def tearDown(self):
        # Clean up by deleting the test books
        for book in self.books:
            response = self.app.delete(f"/reading-list/books/{book['id']}")
            self.assertEqual(response.status_code, 204)

if __name__ == '__main__':
    unittest.main()
