class User < ActiveRecord::Base

  authenticates_with_sorcery!

  has_many :tasks

  validates :email, presence: true, uniqueness: true, email_format: {message: "無効なメールアドレスです"}
  validates :password, presence: true, length: {minimum: 8}, confirmation: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  before_create do |user|
    user.reset_authentication_token
  end

  def reset_authentication_token
    self.authentication_token = generate_authentication_token
  end

  def reset_authentication_token!
    reset_authentication_token
    save!
  end
  
  private
  
  def generate_authentication_token
    loop do
      token = SecureRandom.uuid
      break token unless User.where(authentication_token: token).first
    end
  end

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
  
end

