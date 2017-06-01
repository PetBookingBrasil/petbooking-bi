class Event < ApplicationRecord
  belongs_to :timeslot

  has_one :review

  # Get events by business
  scope :by_businesses, -> (business_ids){
    joins(timeslot: [:employment])
    .where('employments.business_id IN (?)', business_ids) unless business_ids.empty?
  }

  # Get the Event based on when it was sold
  scope :between_sales, -> (start_date, end_date) {
    joins(timeslot: { sales_item: :sales_order })
    .where('sales_orders.created_at >= ? AND sales_orders.created_at <= ?', start_date, end_date)
  }

  # Get the event based on when it occurs (like today, or tomorrow)
  scope :between_timeslots, -> (start_date, end_date) {
    joins(:timeslot)
    .where('timeslots.starts_at >= ? AND timeslots.starts_at <= ?', start_date, end_date)
  }

  scope :online, -> (boolean) {
    joins(timeslot: { sales_item: :sales_order })
    .where('sales_orders.online = ?', boolean)
  }
end
