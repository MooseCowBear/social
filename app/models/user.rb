class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  
  has_one :profile, dependent: :destroy 
  has_many :posts, dependent: :destroy 
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friend_requests, dependent: :destroy
  has_many :friends, -> { where(friend_requests: { status: "accepted" }) }, through: :friend_requests
  has_many :requested_friends, -> { where(friend_requests: { status: "requested" }) }, through: :friend_requests, source: :friend
  has_many :pending_friends, -> { where(friend_requests: { status: "pending" }) }, through: :friend_requests, source: :friend
  has_many :declined_friends, -> { where(friend_requests: { status: "declined" }) }, through: :friend_requests, source: :friend #these are requests user has declined.
  has_many :potential_friends, through: :friend_requests, source: :friend

  has_many :received_requests, class_name: "FriendRequest", foreign_key: "friend_id", dependent: :destroy #think i just need the destroy part...

  scope :all_except, ->(user) { where.not(id: (user.potential_friends + [user]).map(&:id))}

  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]

        #user.skip_confirmation! #add if set up confirmable.
    end
  end

  def get_time_zone
    if self.profile
      self.profile.time_zone
    else
      "Eastern Time (US & Canada)"
    end
  end
end
