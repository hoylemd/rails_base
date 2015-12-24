class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d\-]+\.)*([a-z]+)\z/i

  before_save do
    email.downcase!
  end

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }

  # Returns the hash digest of the given string.
  def self.digest(string)
    if ActiveModel::SecurePassword.min_cost
      cost = BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end
end
