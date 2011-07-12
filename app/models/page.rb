class Page < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  
  validates :user, :presence => true
  validates :title, :presence => true,
                    :length => { :maximum => 255 },
                    :uniqueness => true
end
