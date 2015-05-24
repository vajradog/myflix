class User < ActiveRecord::Base
  has_secure_password validations: false
  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email
  has_many :reviews, -> { order 'created_at DESC' }
  has_many :queue_items,-> { order 'position' }

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
end
