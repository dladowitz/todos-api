class ItemsController < ApplicationController
  def index
    @items = Todo.find(params[:todo_id]).items
    render json: @items, status: 200
  end

  def show
    # todo = Todo.find(params[:todo_id])
    @item = Item.find(id: params[:id], todo_id: params[:todo_id])

    render json: @item, status: 200
  end
end
