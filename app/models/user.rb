class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  
  has_one :profile, dependent: :destroy 

  has_many :friend_requests, dependent: :destroy
  has_many :received_requests, class_name: "FriendRequest", foreign_key: "friend_id"

  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        #user.full_name = auth.info.name 
      
        #user.skip_confirmation! #add if set up confirmable.
    end
  end
end
