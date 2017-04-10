class SalesItem < ApplicationRecord
  belongs_to :sales_order
  belongs_to :employment
  has_one :timeslot
  has_one :event, through: :timeslot

  scope :between, -> (start_date, end_date){
    joins(:sales_order).where('sales_orders.created_at >= ?
                               AND sales_orders.created_at <= ?',
                               start_date, end_date)
  }
end
