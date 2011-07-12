# -*- coding: utf-8 -*-
require 'spec_helper'

describe Comment do
  describe "#page" do
    it "コメント対象のページ" do
      create_comment.page.should be
    end
    
    it "必須" do
      comment = build_comment(:page => nil, :user => create_user)
      comment.should_not be_valid
      comment.errors[:page].should be
    end
  end
  
  describe "#user" do
    it "コメントを投稿したユーザー" do
      create_comment.user.should be
    end
    
    it "必須" do
      comment = build_comment(:page => create_page, :user => nil)
      comment.should_not be_valid
      comment.errors[:user].should be
    end
  end
  
  describe "#body" do
    it "必須" do
      comment = build_comment(:body => "")
      comment.should_not be_valid
      comment.errors[:body].should be
    end
    
    it "1000文字以内" do
      comment = build_comment(:body => "志" * 1001)
      comment.should_not be_valid
      comment.errors[:body].should be
    end
  end
end
