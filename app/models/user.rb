class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true, email_format: {message: "無効なメールアドレスです"}
  validates :password, presence: true, length: {minimum: 8}, confirmation: true
  validates :password_confirmation, presence: true
end
