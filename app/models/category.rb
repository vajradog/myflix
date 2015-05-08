class Category < ActiveRecord::Base
	has_many :videos
	validates :name, presence: true

	def recent_videos	
		if self.videos.count < 6
		  videos
		else
			videos.order('created_at desc').limit(6)
		end
	end



end