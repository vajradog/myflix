class Category < ActiveRecord::Base
  has_many :videos
  validates :name, presence: true

  def recent_videos 
    videos.order('created_at desc').limit(6)
  end



end