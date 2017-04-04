class SalesItem < ApplicationRecord
  belongs_to :sales_order
  has_one :timeslot, dependent: :destroy
  has_one :event, through: :timeslot
end
