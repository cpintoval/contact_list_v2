class Contact < ActiveRecord::Base

  has_many :numbers
  validates :firstname, presence: true, length: { minimum: 2 }
  validates :lastname, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true
  validate :email_validator

  def email_validator
    if !email.include?('@')
      errors.add(:email, "must be a valid email address")
    end
  end
 
end