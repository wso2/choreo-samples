import chai from "chai";
import chaiHttp from "chai-http";
import app from "./app.mjs";

chai.use(chaiHttp);
const expect = chai.expect;

describe("Reading List API", () => {
  describe("POST /reading-list/books", () => {
    it("should add a book to the reading list", async () => {
      const newBook = {
        title: "Test Book",
        author: "Test Author",
        status: "to_read",
      };
      const request = chai.request(app);
      const res = await request.post("/reading-list/books").send(newBook);

      expect(res).to.have.status(201);
      expect(res.body).to.have.property("uuid");
      expect(res.body.title).to.equal(newBook.title);
      expect(res.body.author).to.equal(newBook.author);
    });

    it("should return a 400 Bad Request when the status is invalid", async () => {
      const invalidBook = {
        title: "Invalid Book",
        author: "Invalid Author",
        status: "invalid_status",
      };
      const request = chai.request(app);
      const res = await request.post("/reading-list/books").send(invalidBook);
      expect(res).to.have.status(400);
      expect(res.body.error).to.equal(
        "Status is invalid. Accepted statuses: read | to_read | reading"
      );
    });

    it("should return a 400 Bad Request when title, author, or status is empty", async () => {
      const emptyFieldsBook = {};
      const request = chai.request(app);
      const res = await request
        .post("/reading-list/books")
        .send(emptyFieldsBook);

      expect(res).to.have.status(400);
      expect(res.body.error).to.equal(
        "Status is invalid. Accepted statuses: read | to_read | reading"
      );
    });
  });

  describe("PUT /reading-list/books/:uuid", () => {
    it("should update the status of a book", async () => {
      const newBook = {
        title: "Test Book",
        author: "Test Author",
        status: "to_read",
      };
      const requestOne = chai.request(app);
      const addRes = await requestOne.post("/reading-list/books").send(newBook);

      const updatedStatus = "reading";
      const requestTwo = chai.request(app);
      const updateRes = await requestTwo
        .put(`/reading-list/books/${addRes.body.uuid}`)
        .send({ status: updatedStatus });

      expect(updateRes).to.have.status(200);
      expect(updateRes.body.uuid).to.equal(addRes.body.uuid);
      expect(updateRes.body.status).to.equal(updatedStatus);
    });

    it("should return a 404 Not Found when the UUID does not exist", async () => {
      const nonExistentUuid = "non-existent-uuid";
      const updatedStatus = "reading";
      const request = chai.request(app);
      const res = await request
        .put(`/reading-list/books/${nonExistentUuid}`)
        .send({ status: updatedStatus });

      expect(res).to.have.status(404);
      expect(res.body.error).to.equal("UUID does not exist");
    });

    it("should return a 400 Bad Request when the status is invalid", async () => {
      const newBook = {
        title: "Test Book",
        author: "Test Author",
        status: "to_read",
      };
      const requestOne = chai.request(app);
      const addRes = await requestOne.post("/reading-list/books").send(newBook);

      const updatedStatus = "invalid_status";
      const requestTwo = chai.request(app);
      const updateRes = await requestTwo
        .put(`/reading-list/books/${addRes.body.uuid}`)
        .send({ status: updatedStatus });

      expect(updateRes).to.have.status(400);
      expect(updateRes.body.error).to.equal(
        "Status is invalid. Accepted statuses: read | to_read | reading"
      );
    });
  });

  describe("GET /reading-list/books/:uuid", () => {
    it("should return a book by UUID", async () => {
      const newBook = {
        title: "Test Book",
        author: "Test Author",
        status: "to_read",
      };

      const requestOne = chai.request(app);
      const addRes = await requestOne.post("/reading-list/books").send(newBook);

      const requestTwo = chai.request(app);
      const res = await requestTwo.get(
        `/reading-list/books/${addRes.body.uuid}`
      );

      expect(res).to.have.status(200);
      expect(res.body.uuid).to.equal(addRes.body.uuid);
      expect(res.body.title).to.equal(newBook.title);
      expect(res.body.author).to.equal(newBook.author);
    });

    it("should return a 404 Not Found when the UUID does not exist", async () => {
      const nonExistentUuid = "non-existent-uuid";
      const request = chai.request(app);
      const res = await request.get(`/reading-list/books/${nonExistentUuid}`);

      expect(res).to.have.status(404);
      expect(res.body.error).to.equal("UUID does not exist");
    });
  });
});
