require 'rails_helper'
RSpec.describe 'Todo Items API', type: :request do
  let(:todo)    { create(:todo) }
  let!(:items)  { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id)      { items.first.id }


  describe 'Index GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

    it "gets all the items" do
      json = JSON.parse(response.body)
      expect(json.count).to eq 20
    end

    it "has a status code of 200" do
      expect(response).to have_http_status 200
    end
  end

  describe "Show GET /todos/:todo_id/items/1" do
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

  describe "Create POST /todos/:todo_id/items" do
    before { post "/todos/#{todo_id}/items", params: params }

    context "with valid params" do
      let(:params) { { name: "Practice API specs" } }

      it "has a status code of 201" do
        expect(response).to have_http_status 201
      end

      it "returns the created item" do
        json = JSON.parse(response.body)
        json["name"] = params[:name]
      end
    end

    context "with invalid params" do
      let(:params) { { name: nil } }

      it "has a status status of 422" do
        expect(response.status).to be 422
      end

      it "has an error message" do
        json = JSON.parse(response.body)
        expect(json["message"]).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe "Update PUT /todos/:todo_id/items/1" do
    before { put "/todos/#{todo_id}/items/#{id}", params: params }

    context "with valid params" do
      let(:params) { { name: "Practive SQL" } }

      it "has a code of 204" do
        expect(response.code).to eq "204"
      end

      it "updates the item name" do
        expect(Item.find(id).name).to eq params[:name]
      end

      it "returns an empty body" do
        expect(response.body).to be_empty
      end
    end

    context "with invalid params" do
      let(:params) { { name: nil } }

      it "has a status of 422" do
        expect(response.status).to eq 422
      end

      it "has an error message" do
        expect(response.body

        ).to match /Validation/
      end
    end
  end

  describe "Destroy DELETE /todos/:todo_id/items/1" do
    before { delete "/todos/#{todo_id}/items/#{id}" }

    context "with valid params" do
      it "has status of 204" do
        expect(response).to have_http_status 204
      end

      it "deletes the item" do
        expect(Item.find_by(id: id)).to be_nil
      end
    end

    context "with invalid params" do
      let(:id) { 100 }

      it "has status of 404" do
        expect(response.code).to eq "404"
      end

      it "does not delete any items" do
        expect(Item.count).to eq 20
      end
    end
  end
end
