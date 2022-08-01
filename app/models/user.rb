class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = Settings.user.valid_email_regex
  USER_ATTRIBUTES = %i(name email password password_confirmation).freeze
  validates :email, presence: true,
    length: {in: Settings.user.email_length},
    format: {with: VALID_EMAIL_REGEX}

  validates :name, presence: true, length: {maximum: Settings.user.name_max}

  validates :password, presence: true,
    length: {minimum: Settings.user.pass_min}, allow_nil: true

  has_secure_password
  before_save :downcase_email

  scope :order_by_id, ->{order(id: :asc)}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_token

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private
  def downcase_email
    email.downcase!
  end
end
