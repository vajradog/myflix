class Category < ActiveRecord::Base
	has_many :videos, -> { order("title")}
	validates :name, presence: true

	def recent_videos	
		if self.videos.count < 6
		  videos.all
		else
			videos.limit(6).order("created_at DESC")
		end
	end



end