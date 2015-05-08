class Category < ActiveRecord::Base
<<<<<<< HEAD
	has_many :videos
	validates :name, presence: true

	def recent_videos	
    videos.order('created_at desc').limit(6)
	end
=======
  has_many :videos
  validates :name, presence: true

  def recent_videos 
    videos.order('created_at desc').limit(6)
  end



>>>>>>> forms_and_authentication
end