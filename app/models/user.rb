class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

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
  before_create :create_activation_digest

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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.blank?

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_mail_activate
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
