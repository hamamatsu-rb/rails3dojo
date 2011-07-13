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
    before do
      @page = create_page
      @older = @page.comments.create(:body => "First", :user => @page.user)
      @newer = @page.comments.create(:body => "Second", :user => create_user(:name => "tom"))
    end
    
    it "複数持つ" do
      @page.comments.should be_many
    end
    
    it "作成日の昇順でソート" do
      @page.comments.first.should eql(@older)
    end
        
    it "Pageと一緒に全て削除" do
      lambda do
        @page.destroy
      end.should change(Comment, :count).by(-2)
    end
  end
  
  describe "#histories" do
    before do
      @page = create_page
      @older = @page.histories.create(:user => @page.user)
      @newer = @page.histories.create(:user => create_user(:name => "tom"))
    end
    
    it "複数持つ" do
      @page.histories.should be_many
    end
    
    it "作成日の降順でソート" do
      @page.histories.first.should eql(@newer)
    end
    
    it "Pageと一緒に全て削除" do
      lambda do
        @page.destroy
      end.should change(History, :count).by(-2)
    end
  end
  
  describe "#recent" do
    before do
      @oldest = create_page
      9.times do
        create_page(:user => @oldest.user)
      end
      @newest = create_page(:user => @oldest.user)
    end
    
    it "最新の10件" do
      Page.recent.all.size.should eql(10)
    end
    
    it "作成日の降順でソート" do
      Page.recent.first.should eql(@newest)
      Page.recent.should_not be_include(@oldest)
    end
  end
end
