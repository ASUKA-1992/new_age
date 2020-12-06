class Member < ApplicationRecord
  validates :name, presence: true,
    length: {mimimum: 4, maximum: 15, allow_blank: true}

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :mail, {presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }}

    validates :password, format: { with: /\A[a-z0-9]+\z/i }, length: { in: 6..15}
  has_secure_password

end
