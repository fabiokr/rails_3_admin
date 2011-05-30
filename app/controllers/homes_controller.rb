class HomesController < ApplicationController

  managable_content_for :body

  def index
    view_context.content_for :test, 'Hi'
    puts "CONTENT: " + view_context.content_for(:test)
  end
end
