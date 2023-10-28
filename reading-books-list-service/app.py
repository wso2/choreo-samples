from flask import Flask, jsonify, request

app = Flask(__name__)

books = []

# helper function to generate IDs
def generate_id():
    return len(books) + 1

# endpoint to get all books
@app.route('/reading-list/books', methods=['GET'])
def get_books():
    return jsonify({'books': books})

# endpoint to add a new book
@app.route('/reading-list/books', methods=['POST'])
def add_book():
    data = request.get_json()
    book = {
        'id': generate_id(),
        'author': data['author'],
        'name': data['name'],
        'status': data['status']
    }
    books.append(book)
    return jsonify(book)

# endpoint to get a book by ID
@app.route('/reading-list/books/<int:book_id>', methods=['GET'])
def get_book(book_id):
    for book in books:
        if book['id'] == book_id:
            return jsonify(book)
    return '', 404

# endpoint to delete a book by ID
@app.route('/reading-list/books/<int:book_id>', methods=['DELETE'])
def delete_book(book_id):
    global books
    books = [book for book in books if book['id'] != book_id]
    return '', 204

# endpoint to update a book status by ID
@app.route('/reading-list/books/<int:book_id>', methods=['PUT'])
def update_book_status(book_id):
    data = request.get_json()
    for book in books:
        if book['id'] == book_id:
            book['status'] = data['status']
            return jsonify(book)
    return '', 404

if __name__ == '__main__':
    app.run()
