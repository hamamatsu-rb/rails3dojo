# -*- coding: utf-8 -*-
require 'spec_helper'

describe WelcomeController do

  describe "#index" do
    it "GET root_path にマッチ" do
      { :get => root_path }.should route_to(:controller => "welcome", :action => "index")
    end
    
    context "'Home'というタイトルのPageが存在する場合" do
      before do
        home = create_page(:title => "Home")
        create_page(:title => "Other", :user => home.user)
        get :index
      end
      
      it "テンプレート pages/show を表示する" do
        response.should render_template('pages/show')
      end
      
      it "'Home'を表示する" do
        assigns(:page).title.should eql("Home")
      end
    end
    
    context "Page 'Home'が存在しない場合" do
      before do
        home = create_page(:title => "Other")
        get :index
      end
      
      it "テンプレート index を表示する" do
        response.should render_template(:index)
      end
      
      it "Pageはアサインされない" do
        assigns(:page).should_not be
      end
    end
  end
end
