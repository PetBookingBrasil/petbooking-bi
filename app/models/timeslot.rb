class Timeslot < ApplicationRecord
  belongs_to :sales_item
  belongs_to :employment
  has_one :event

  scope :between, -> (start_date, end_date) {
    where('timeslots.starts_at >= ? AND timeslots.starts_at <= ?', start_date, end_date)
  }
end
