# -*- coding: utf-8 -*-
require 'spec_helper'

describe Page do
  describe "#user" do
    it "ページを作成したユーザー" do
      create_page.user.should be
    end
    
    it "必須" do
      page = build_page(:user => nil)
      page.should_not be_valid
      page.errors[:user].should be
    end
  end
  
  describe "#title" do
    it "必須" do
      page = build_page(:title => "")
      page.should_not be_valid
      page.errors[:title].should be
    end
    
    it "255文字以内" do
      page = build_page(:title => "魂" * 256)
      page.should_not be_valid
      page.errors[:title].should be
    end
    
    it "重複不可" do
      page = create_page
      copy = build_page(:title => page.title, :user => page.user)
      copy.should_not be_valid
      copy.errors[:title].should be
    end
  end
  
  describe "#body" do
    it "文字数は実質無制限" do
      lambda do
        create_page(:body => "命" * 10_000)
      end.should change(Page, :count).by(1)
    end
  end
  
  describe "#comments" do
    it "複数持てる" do
      page = create_page
      page.comments.should be_empty
    end
    
    it "追加できる" do
      page = create_page
      lambda do
        page.comments.create(:body => "こんにちは", :user => page.user)
      end.should change(Comment, :count).by(1)      
    end
  end
end
