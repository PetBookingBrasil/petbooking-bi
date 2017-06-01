class Timeslot < ApplicationRecord
  belongs_to :sales_item
  belongs_to :employment
  has_one :event
  has_one :business, through: :employment

  scope :between, -> (start_date, end_date){
    where('timeslots.starts_at >= ? AND timeslots.starts_at <= ?', start_date, end_date)
  }

  scope :by_businesses, -> (business_ids){
    joins(:employment)
    .where('employments.business_id IN (?)', business_ids) unless business_ids.empty?
  }
end
