# -*- coding: utf-8 -*-
require 'spec_helper'

describe History do
  describe "#page" do
    it "履歴の対象のページ" do
      create_history.page.should be
    end
  end
  
  describe "#user" do
    it "履歴を更新したユーザー" do
      create_history.user.should be
    end
  end
end
