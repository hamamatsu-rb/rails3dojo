class Page < ActiveRecord::Base
  belongs_to :user
  has_many :comments,  :order => "created_at ASC",  :dependent => :delete_all
  has_many :histories, :order => "created_at DESC", :dependent => :delete_all
  
  validates :user, :presence => true
  validates :title, :presence => true,
                    :length => { :maximum => 255 },
                    :uniqueness => true
                    
  scope :recent, limit(10).order("created_at DESC")
end
