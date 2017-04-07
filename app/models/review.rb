class Review < ActiveRecord::Base
  belongs_to :event
  has_one :clientship, through: :event
  has_one :business,   through: :clientship
end
