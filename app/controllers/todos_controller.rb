class TodosController < ApplicationController
  def index
    @todos = Todo.all
    render json: @todos, status: 200
  end

  def show
    @todo = Todo.find(params[:id])
    render json: @todo, status: 200
  end

  def create
    @todo = Todo.create!(todo_params)
    render json: @todo, status: 201
  end

  def update
    Todo.find(params[:id]).update(todo_params)
    head :no_content
  end

  def destroy
    Todo.find(params[:id]).delete
    head :no_content
  end

  private

  def todo_params
    params.permit(:title, :created_by)
  end
end
