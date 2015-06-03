class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"
  validates_presence_of :friends_name, :friends_email, :message
  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def destroy_token
    update_column(:token, nil)
  end
end
