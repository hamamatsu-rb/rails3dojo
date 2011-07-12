# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  describe "#name" do    
    it "必須" do
      user = build_user(:name => "")
      user.should_not be_valid
    end
    
    it "50文字以内" do
      user = build_user(:name => "あ" * 51)
      user.should_not be_valid
    end
    
    it "重複できない" do
      user = create_user
      copy = build_user(:name => user.name)
      copy.should_not be_valid
    end
  end
  
  describe "#find_or_create_by_name" do
    context "同じ名前のユーザーが存在する場合" do
      it "存在しているユーザーを取得する" do
        exist = create_user
        lambda do
          user = User.find_or_create_by_name(exist.name)
          user.should eql(exist)
        end.should_not change(User, :count)
      end
    end
    
    context "同じ名前のユーザーが存在しない場合" do
      it "新しいユーザーを作成する" do
        lambda do
          user = User.find_or_create_by_name("tom")
          user.name.should eql("tom")
        end.should change(User, :count).by(1)
      end
    end
  end
end
