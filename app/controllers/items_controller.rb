class ItemsController < ApplicationController
  def index
    @items = Todo.find(params[:todo_id]).items
    render json: @items, status: 200
  end

  def show
    @item = Item.where(todo_id: params[:todo_id]).find(params[:id])
    render json: @item, status: 200
  end

  def create
    @item = Todo.find(params[:todo_id]).items.create!(item_params)
    render json: @item, status: 201
  end

  def update
    @item = Item.where(todo_id: params[:todo_id]).find(params[:id])
    @item.update_attributes!(item_params)

    head :no_content
  end

  def destroy
    @item = Item.where(todo_id: params[:todo_id]).find(params[:id])
    @item.delete

    head :no_content
  end

  private

  def item_params
    params.permit(:name)
  end
end
