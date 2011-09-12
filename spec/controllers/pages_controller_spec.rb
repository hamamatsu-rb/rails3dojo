# -*- coding: utf-8 -*-
require 'spec_helper'

describe PagesController do

  describe "#index" do
    it "GET pages_path にマッチ" do
      { :get => pages_path }.should route_to("pages#index" )
    end
    
    before do
      create_page(:user => create_page.user)
      get :index
    end
    
    it "テンプレートindexを表示する" do
      response.should render_template(:index)
    end

    it "最新のPageのリストを表示する" do
      pages = assigns(:pages)
      pages.first.created_at.should > pages.last.created_at
    end
  end
  
  describe "#show" do
    it "GET wiki_page_path(title)にマッチ" do
      { :get => wiki_page_path(:title => "Home") }.should route_to("pages#show", :title => "Home")
    end
    
    context "Pageが存在する場合" do
      before do
        @page = create_page
        get :show, :title => @page.title
      end
      
      it "テンプレートshowを表示する" do
        response.should render_template(:show)
      end
      
      it "タイトルが一致するPageを表示する" do
        assigns(:page).title.should eql(@page.title)
      end
    end
    
    context "Pageが存在しない場合" do
      context "ログインしていない場合" do
        it "トップページにリダイレクトする" do
          get :show, :title => "New Page"
          response.should redirect_to(root_path)
        end
      end
      
      context "ログイン済みの場合" do
        before do
          login
          get :show, :title => "New Page"
        end
      
        it "テンプレートnewを表示する" do
          response.should render_template(:new)
        end
      
        it "タイトルは入力済み" do
          assigns(:page).title.should eql("New Page")
        end
      
        it "未作成Pageメッセージを表示する" do
          flash[:notice].should be
        end        
      end
    end
  end

  describe "#new" do
    it "GET new_page_path にマッチ" do
      { :get => new_page_path }.should route_to("pages#new")
    end
    
    context "ログインしていない場合" do
      before do
        get :new
      end
      
      it "トップページにリダイレクトする" do
        response.should redirect_to(root_path)
      end
      
      it "ログイン要求メッセージを表示する" do
        flash[:error].should be
      end
    end
    
    context "ログイン済みの場合" do
      before do
        login
        get :new
      end
      
      it "テンプレートnewを表示する" do
        response.should render_template(:new)
      end
      
      it "新規Page作成フォームを表示する" do
        assigns(:page).should be_new_record
      end
    end
  end

  describe "#create" do
    it "POST pages_pathにマッチ" do
      { :post => pages_path }.should route_to("pages#create")
    end
    
    before do
      login
    end
    
    it "ログインが必要" do
      logout
      post :create
      filtered_by_login_required
    end
    
    context "正しいデータが送信された場合" do
      before do
        @before_count = Page.count
        post :create, :page => { :title => "New Page" }
      end
      
      it "Wikiページにリダイレクトする" do
        response.should redirect_to(wiki_page_path("New Page"))
      end
      
      it "成功メッセージが表示される" do
        flash[:notice].should be
      end
      
      it "新しいPageが作成される" do
        Page.count.should eql(@before_count + 1)
      end
    end
    
    context "不正なデータが送信された場合" do
      before do
        post :create, :page => { :title => "" }
      end
      
      it "テンプレートnewを表示する" do
        response.should render_template(:new)
      end
      
      it "入力エラーメッセージを表示する" do
        flash[:error].should be
      end
    end
  end
  
  describe "#edit" do
    it "GET edit_page_path(id)にマッチ" do
      { :get => edit_page_path("1") }.should route_to("pages#edit", :id => "1")
    end
    
    before do
      login
    end
    
    it "ログインが必要" do
      logout
      get :edit, :id => 1
      filtered_by_login_required
    end
    
    context "Pageが存在する場合" do
      before do
        @page = create_page(:user => controller.current_user)
        get :edit, :id => @page.id
      end
      
      it "テンプレートeditを表示する" do
        response.should render_template(:edit)
      end

      it "Page編集フォームを表示する" do
        assigns(:page).should_not be_new_record
      end
    end
    
    context "Pageが存在しない場合" do
      it "例外RecordNotFoundを投げる" do
        lambda do
          get :edit, :id => 99999
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  describe "#update" do
    it "PUT page_path(id)にマッチ" do
      { :put => page_path("1") }.should route_to("pages#update", :id => "1")
    end
    
    before do
      login
    end
    
    it "ログインが必要" do
      logout
      put :update, :id => 1
      filtered_by_login_required
    end
    
    context "正しいデータが送信された場合" do
      before do
        @page = create_page(:user => controller.current_user)
        @before_histries_count = @page.histories.count
        put :update, :id => @page.id, :page => { :title => "New Title" }
      end
      
      it "Wikiページにリダイレクトする" do
        response.should redirect_to(wiki_page_path("New Title"))
      end
      
      it "成功メッセージが表示される" do
        flash[:notice].should be
      end
      
      it "Pageが更新される" do
        assigns(:page).should be_valid
        assigns(:page).title.should eql("New Title")
      end
      
      it "Historyが追加される" do
        assigns(:page).histories.count.should eql(@before_histries_count + 1)
      end
    end
    
    context "不正なデータが送信された場合" do
      before do
        @page = create_page(:user => controller.current_user)
        put :update, :id => @page.id, :page => { :title => "" }
      end
      
      it "テンプレートeditを表示する" do
        response.should render_template(:edit)
      end
      
      it "入力エラーメッセージを表示する" do
        flash[:error].should be
      end
    end
    
    context "Pageが存在しない場合" do
      it "例外RecordNotFoundを投げる" do
        lambda do
          put :update, :id => 99999
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  describe "#destroy" do
    it "DELETE page_path(id)にマッチ" do
      { :delete => page_path("1") }.should route_to("pages#destroy", :id => "1")
    end
    
    before do
      login
    end
    
    it "ログインが必要" do
      logout
      put :destroy, :id => 1
      filtered_by_login_required
    end
    
    context "Pageが存在する場合" do
      before do
        @page = create_page(:user => controller.current_user)
        @before_count = Page.count
        put :destroy, :id => @page.id
      end
      
      it "Homeにリダイレクトする" do
        response.should redirect_to(root_path)
      end
      
      it "成功メッセージを表示する" do
        flash[:notice].should be
      end
      
      it "Pageが削除される" do
        Page.count.should eql(@before_count - 1)
      end
    end
    
    context "Pageが存在しない場合" do
      it "例外RecordNotFoundを投げる" do
        lambda do
          put :destroy, :id => 99999
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
