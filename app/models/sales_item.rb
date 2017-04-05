class SalesItem < ApplicationRecord
  belongs_to :sales_order
  belongs_to :employment
  has_one :timeslot
  has_one :event, through: :timeslot
end
