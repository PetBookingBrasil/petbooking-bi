class Event < ApplicationRecord
  belongs_to :timeslot
  has_one :review

  scope :between, -> (start_date, end_date) {
    where('events.created_at >= ? AND events.created_at <= ?', start_date, end_date)
  }

  scope :online, -> (boolean) {
    joins(timeslot: { sales_item: :sales_order }).
    where('sales_orders.online = ?', boolean)
  }
end
