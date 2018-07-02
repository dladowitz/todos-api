require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:todo) { create_list(:todo, 10) }
  let(:todo_it) { todos.first.id }

  describe 'Get /todos' do
    before { get '/todos' }

    it "returns todos" do
      expect(json).not_to be_empty
      expect(json.size).to eq 10
    end

    it "returns status code 200" do
      expect(response).to have_http_status 200
    end
  end
end
