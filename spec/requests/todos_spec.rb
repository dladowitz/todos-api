require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  describe 'GET /todos' do
    before { get '/todos' }

    it "returns todos" do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.size).to eq 10
    end

    it "returns status code 200" do
      expect(response).to have_http_status 200
      expect(response.code).to eq "200"
    end
  end

  describe "GET /todos/:id" do
    before { get "/todos/#{todo_id}" }

    context "when the record exists" do
      it "returns the todo" do
        json = JSON.parse(response.body)

        expect(json['id']).to eq todo_id
        expect(json).not_to be_empty
      end

      it "returns status code 200" do
        expect(response).to have_http_status 200
      end
    end

    context "when the record does not exist" do
      let(:todo_id) { 100 }

      it "returns status code 404" do
        expect(response).to have_http_status 404
      end

      it "returns error message" do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe "POST /todos" do
    let(:attributes) { { title: "Learn Elm", created_by: 10 } }
    before { post "/todos", params: attributes }

    context "with valid params" do
      it "has http code of 201" do
        expect(response).to have_http_status 201
      end

      it "returns the correct todo" do
        json = JSON.parse(response.body)
        expect(json["title"]).to eq "Learn Elm"
      end
    end

    context "with invalid params" do
      let(:attributes) { { title: "Invalid" } }

      it "has http code 422" do
        expect(response).to have_http_status 422
      end

      it "has error message" do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  describe "PUT /todos/:id" do
    let(:params) { { title: "Go Shopping" } }
    before { put "/todos/#{todo_id}", params: params }

    it "updates the title" do
      expect(Todo.find(todo_id).title).to eq params[:title]
    end

    it "returns an empty body" do
      expect(response.body).to be_empty
    end

    it "returns http code of 204" do
      expect(response).to have_http_status 204
    end
  end

  describe "DELETE /todo/:id" do
    before { delete "/todos/#{todo_id}" }

    it "returns http status 204" do
      expect(response).to have_http_status 204
    end

    it "deletes the todo" do
      expect(Todo.find_by(id: todo_id)).to be_nil
    end
  end
end
