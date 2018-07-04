require 'rails_helper'
RSpec.describe 'Todo Items API', type: :request do
  let(:todo)    { create(:todo) }
  let!(:items)  { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id)      { items.first.id }


  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

    it "gets all the items" do
      json = JSON.parse(response.body)
      expect(json.count).to eq 20
    end

    it "has a status code of 200" do
      expect(response).to have_http_status 200
    end
  end

  describe "GET /todos/:todo_id/items/1" do
    context "when the item belongs to the todo" do
      before { get "/todos/#{todo_id}/items/1" }

      it "should return an item" do
        json = JSON.parse(response.body)
        expect(json["name"]).to eq Item.find(1).name
      end

      it "has status code of 200" do
        expect(response.status).to eq 200
      end
    end

    context "when the item does NOT belong to the todo" do
      let(:other_todo_id) { 2 }
      before { get "/todos/#{other_todo_id}/items/1" }

      it "should not return an item" do
        json = JSON.parse(response.body)
        expect(json["message"]).to match(/Couldn't find Item/)
      end

      it "has a status code of 404" do
        expect(response.code).to eq "404"
      end
    end
  end
end
