class HomesController < ApplicationController

  managable_content_for :body, :side

  def index
    view_context.content_for :test, 'Hi'
    puts "CONTENT: " + view_context.content_for(:test)
  end
end
