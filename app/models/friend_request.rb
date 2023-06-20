class FriendRequest < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates_presence_of :user_id, :friend_id
  validates_uniqueness_of :user_id, scope: [:friend_id]
  validate :not_self

  enum :status, {pending: 0, requested: 1, accepted: 2, declined: 3}

  def self.send_request(sender, receiver)
    transaction do
      #create 2 rows in the table, one for each side of the relationship
      #because of validation, should not allow multiple requests between pair
      create!(user_id: sender.id, friend_id: receiver.id, status: "requested") 
      create!(user_id: receiver.id, friend_id: sender.id, status: "pending")
    end
    rescue ActiveRecord::RecordInvalid 
      return false
  end

  def self.accept_request(sender, receiver)
    transaction do
      #update both sides to accepted
      update_side(sender, receiver, "accepted")
      update_side(receiver, sender, "accepted")
    end
    rescue ActiveRecord::RecordInvalid
      return false
  end

  def self.decline_request(sender, receiver)
    update_side(receiver, sender, "declined") 
    rescue ActiveRecord::RecordInvalid
      return false
  end

  def self.unfriend(a, b)
    side_one = find_by(user_id: a, friend_id: b)
    side_two = find_by(user_id: b, friend_id: a)
    return false unless side_one && side_two
    
    transaction do
      #remove both rows from the table if the friendship  
      side_one.destroy
      side_two.destroy
    end

  end

  def recipients
    [friend_id]
  end

  private

  def self.update_side(a, b, new_status)
    request = find_by(user_id: a.id, friend_id: b.id)
    raise ActiveRecord::RecordInvalid unless request
    request.update!(status: new_status)
  end

  def not_self
    user_id != friend_id
  end
end
