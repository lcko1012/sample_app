class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.regex.email

  validates :name, presence: true,
            length: {maximum: Settings.digits.name_max_length}
  validates :email, presence: true,
            length: {maximum: Settings.digits.email_max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  validates :password, presence: true,
            length: {minimum: Settings.digits.password_min_length}

  before_save :downcase_email

  private

  has_secure_password

  def downcase_email
    email.downcase!
  end
end
