class CommentsController < ApplicationController
  before_filter :login_required
  
  def create
    @page = Page.find(params[:page_id])
    @comment = @page.comments.build(params[:comment])
    @comment.user = current_user
    
    if @comment.save
      flash[:notice] = "Comment was created."
    else
      flash[:error] = "Comment could not create."      
    end
    
    redirect_to wiki_page_path(:title => @page.title)
  end

  def destroy
    @page = Page.find(params[:page_id])
    @comment = @page.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Comment was deleted."
    
    redirect_to wiki_page_path(:title => @page.title)
  end
end
