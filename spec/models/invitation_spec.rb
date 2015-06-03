require "rails_helper"

describe Invitation do
  it { should validate_presence_of(:friends_name) }
  it { should validate_presence_of(:friends_email) }
  it { should validate_presence_of(:message) }
  it { should belong_to(:inviter) }
end
