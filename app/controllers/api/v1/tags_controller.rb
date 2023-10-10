class Api::V1::TagsController < ApplicationController
  before_action :authenticate, except: %i[index]
  def index
    tags = Tag.joins(:record_tags).group('tags.id').order('COUNT(record_tags.id) DESC')
    render json: tags
  end
end
