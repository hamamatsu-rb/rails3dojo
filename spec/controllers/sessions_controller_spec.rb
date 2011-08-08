# -*- coding: utf-8 -*-
require 'spec_helper'

describe SessionsController do

  describe "#create" do
    it "POST sessions_path にマッチ" do
      { :post => sessions_path }.should route_to(:controller => "sessions", :action => "create")
    end
    
    context "ログインに成功した場合" do
      before do
        @user = create_user
        post :create, :user_name => @user.name, :before_path => pages_path
      end
      
      it "ログイン前のページにリダイレクトする" do
        response.should redirect_to(pages_path)
      end
      
      it "セッションにログインユーザーのidがセットされる" do
        session[:user_id].should eql(@user.id)
      end
      
      it "ログインユーザーの情報が取得できる" do
        controller.current_user.should eql(@user)
      end
    end
    
    context "ログインに失敗した場合" do
      before do
        @create_user
        post :create, :user_name => "", :before_path => root_path
      end
      
      it "リダイレクトしない" do
        response.should be_success        
      end
      
      it "レスポンスボディはエラーメッセージ" do
        response.body.should_not be_blank
      end
    end
    
    context "存在しないユーザー名でログイン要求した場合" do
      it "ログインは成功する" do
        post :create, :user_name => "tom", :before_path => root_path
        response.should redirect_to(root_path)
      end
      
      it "新しいユーザーが追加される" do
        lambda do
          post :create, :user_name => "tom", :before_path => root_path
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "#destroy" do
    it "DELETE session_path(id) にマッチ" do
      { :delete => session_path("1") }.should \
        route_to(:controller => "sessions", :action => "destroy", :id => "1")
    end
    
    before do
      @user = create_user
      session[:user_id] = @user.id
      delete :destroy, :id => session[:user_id], :before_path => pages_path
    end
    
    it "ログアウト前のページにリダイレクトする" do
      response.should redirect_to(pages_path)
    end
    
    it "セッションのuser_idがクリアされる" do
      session[:user_id].should_not be
    end
    
    it "ログインユーザーの情報は取得できない" do
      controller.current_user.should_not be
    end
  end

end
