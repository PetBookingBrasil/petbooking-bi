class Employment < ActiveRecord::Base
  belongs_to :user
  belongs_to :business
  has_many :events, through: :timeslots
  has_many :timeslots
  has_many :sales_items
end
