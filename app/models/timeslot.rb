class Timeslot < ApplicationRecord
  belongs_to :sales_item
  has_one :event, dependent: :destroy
end
