class User < ActiveRecord::Base
  has_many :products
  attr_accessible :job_title, :name
end
