class Page < ActiveRecord::Base
  belongs_to :user
  
  validates :user, :presence => true
  validates :title, :presence => true,
                    :length => { :maximum => 255 },
                    :uniqueness => true
end
