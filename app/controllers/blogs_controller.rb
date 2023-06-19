class BlogsController < ApplicationController
  def index
    blogs = Blog.all
    render json: blogs
  end

  def show
    blog = Blog.find(params[:id])
    render json: blog
  end

  def create
    Blog.create(blog_params)
    head :created
  end

  private
  
  def blog_params
    params.require(:blog).permit(:title, :contents)
  end
end
