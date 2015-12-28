class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d\-]+\.)*([a-z]+)\z/i
  attr_accessor :remember_token, :activation_token

  before_create :create_activation
  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  # Returns the hash digest of the given string.
  def self.digest(string)
    if ActiveModel::SecurePassword.min_cost
      cost = BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private

  # Creates the activation token
  def create_activation
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # normalize emails
  def downcase_email
    email.downcase!
  end
end
