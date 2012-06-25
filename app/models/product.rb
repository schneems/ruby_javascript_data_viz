class Product < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :price
  validates :name, :uniqueness => true
end
