class Number < ActiveRecord::Base

  belongs_to :contact
  #validates :contact_id, presence: true
  validates :tag, presence: true
  validates :number, presence: true, length: { minimum: 8 }

end