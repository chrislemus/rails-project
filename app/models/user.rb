class User < ApplicationRecord
  has_many :businesses, :foreign_key => 'owner_id'
  has_many :reviews
  has_many :business_reviews, through: :businesses, source: :reviews
  has_many :categories, through: :businesses

  validates :email, presence: true
  validates :first_name, presence: true
  validates :email, uniqueness: true
  validates :password, length: {minimum: 8}
  has_secure_password

  def full_name
    full_name = first_name
    full_name += " #{last_name}" if !last_name.empty?
    full_name
  end

  def owner?
    !businesses.empty?
  end

  

end


