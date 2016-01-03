class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d\-]+\.)*([a-z]+)\z/i
  attr_accessor :remember_token, :verification_token, :reset_token

  before_create :create_verification
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
  def authenticated?(token_type, token)
    digest = send "#{token_type}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def verify_email
    update_attribute(:verified, true)
    update_attribute(:verified_at, Time.zone.now)
  end

  # Sends activation email.
  def send_verification_email
    UserMailer.email_verification(self).deliver_now
  end

  # Sends activation email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Creates the password reset token
  def create_password_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  private

  # Creates the verification token
  def create_verification
    self.verification_token = User.new_token
    self.verification_digest = User.digest(verification_token)
  end

  # normalize emails
  def downcase_email
    email.downcase!
  end
end
