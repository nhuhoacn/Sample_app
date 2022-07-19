class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.user.valid_email_regex
  USER_ATTRIBUTES = %i(name email password password_confirmation).freeze
  validates :email, presence: true,
    length: {in: Settings.user.email_length},
    format: {with: VALID_EMAIL_REGEX}

  validates :name, presence: true, length: {maximum: Settings.user.name_max}

  validates :password, presence: true,
    length: {minimum: Settings.user.pass_min}, if: :password

  has_secure_password
  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
