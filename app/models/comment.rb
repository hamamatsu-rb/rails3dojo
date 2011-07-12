class Comment < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  
  validates :page, :presence => true
  validates :user, :presence => true
  validates :body, :presence => true,
                   :length => { :maximum => 1000 }
end
