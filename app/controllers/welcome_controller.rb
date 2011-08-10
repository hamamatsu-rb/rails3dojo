class WelcomeController < ApplicationController
  def index
    @page = Page.find_by_title("Home")
    render :template => 'pages/show' if @page
  end
end
