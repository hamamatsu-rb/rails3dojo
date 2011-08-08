# -*- coding: utf-8 -*-
require 'spec_helper'

describe PagesController do

  describe "#index'" do
    it "GET pages_path にマッチ" do
      { :get => pages_path }.should route_to(:controller => "pages", :action => "index" )
    end
  end

  describe "#new'" do
    it "GET new_page_path にマッチ" do
      { :get => new_page_path }.should route_to(:controller => "pages", :action => "new" )
    end
  end

end
