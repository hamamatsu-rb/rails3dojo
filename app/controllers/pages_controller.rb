class PagesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  
  def index
    @pages = Page.recent
  end
  
  def show
    @page = Page.find_by_title(params[:title])
    
    unless @page
      flash.now[:notice] = "Page could not create."
      @page = Page.new(:title => params[:title])
      render :action => :new
    end
  end

  def new
    @page = Page.new
  end
  
  def create
    @page = Page.new(params[:page])
    @page.user = current_user
    
    if @page.save
      flash[:notice] = "Page was created."
      redirect_to wiki_page_path(@page.title)
    else
      flash.now[:error] = "Page could not create."
      render :action => :new
    end
  end
  
  def edit
    @page = Page.find(params[:id])
  end
  
  def update
    @page = Page.find(params[:id])
    @page.attributes = params[:page]
    
    if @page.save_by_user(current_user)
      flash[:notice] = "Page was updated."
      redirect_to wiki_page_path(@page.title)
    else
      flash.now[:error] = "Page could not update."
      render :action => :edit
    end
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    flash[:notice] = "Page was deleted."
    redirect_to root_path
  end
end
