class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :friends_email, :friends_name
      t.text :message
      t.integer :inviter_id
      t.timestamps
    end
  end
end
