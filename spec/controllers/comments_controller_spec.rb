# -*- coding: utf-8 -*-
require 'spec_helper'

describe CommentsController do

  describe "#create" do
    it "POST page_comments_path(page_id) にマッチ" do
      { :post => page_comments_path("1") }.should route_to("comments#create", :page_id => "1")
    end
    
    before do
      login
      @page = create_page(:user => controller.current_user)
      @before_count = @page.comments.count
    end
    
    it "ログインが必要" do
      logout
      post :create, :page_id => 1
      filtered_by_login_required
    end
    
    context "コメントが入力されている場合" do
      before do
        post :create, :page_id => @page.id, :comment => { :body => "Comment...." }
      end
      
      it "Wikiページにリダイレクトする" do
        response.should redirect_to(wiki_page_path(:title => @page.title))
      end
      
      it "成功メッセージを表示する" do
        flash[:notice].should be
      end
      
      it "Commentが追加される" do
        assigns(:page).comments.count.should eql(@before_count + 1)
      end
    end
    
    context "コメントが入力されていない場合" do
      before do
        post :create, :page_id => @page.id, :comment => { :body => "" }
      end
      
      it "Wikiページにリダイレクトする" do
        response.should redirect_to(wiki_page_path(:title => @page.title))
      end
      
      it "エラーメッセージを表示する" do
        flash[:error].should be
      end
    end
  end

  describe "GET 'destroy'" do
    it "DELETE page_comment_path(page_id, id) にマッチ" do
      { :delete => page_comment_path("1", "2") }.should route_to("comments#destroy", :page_id => "1", :id => "2")
    end
    
    before do
      login
      @page = create_page(:user => controller.current_user)
      @comment = @page.comments.create(:user => controller.current_user, :body => "Comment...")
      @before_count = @page.comments.count
    end
    
    it "ログインが必要" do
      logout
      delete :destroy, :page_id => @page.id, :id => @comment.id
      filtered_by_login_required
    end
    
    context "データを正しく指定した場合" do
      before do
        delete :destroy, :page_id => @page.id, :id => @comment.id
      end
      
      it "Wikiページにリダイレクトする" do
        response.should redirect_to(wiki_page_path(:title => @page.title))
      end
      
      it "成功メッセージを表示する" do
        flash[:notice].should be
      end

      it "コメントが削除される" do
        assigns(:page).comments.count.should eql(@before_count - 1)
      end
    end
    
    context "データが存在しない場合" do
      it "例外RecordNotFoundを投げる" do
        lambda do
          delete :destroy, :page_id => 999, :id => @comment.id
        end.should raise_error(ActiveRecord::RecordNotFound)
        
        lambda do
          delete :destroy, :page_id => @page.id, :id => 999
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end 
  end
end
