class SalesItem < ApplicationRecord
  belongs_to :sales_order
  belongs_to :employment
  has_one :timeslot
  has_one :event, through: :timeslot

  scope :between, -> (start_date, end_date){
    joins(:sales_order).where('sales_orders.consumed_on >= ?
                               AND sales_orders.consumed_on <= ?',
                               start_date, end_date)
  }

  # Get SalesItem by business
  scope :by_businesses, -> (business_ids){
    joins(:employment)
    .where('employments.business_id IN (?)', business_ids) unless business_ids.empty?
  }

end
