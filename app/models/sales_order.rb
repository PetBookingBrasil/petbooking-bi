class SalesOrder < ApplicationRecord
  AASM_STATES = { cancelled: 0, open: 1, payment: 2, paid: 3 }

  belongs_to :clientship
  has_many :sales_items
  has_many :timeslots, through: :sales_items

  scope :paid, -> { where(aasm_state: AASM_STATES[:paid]) }
  scope :online, -> (boolean) { where(online: boolean) }
  scope :between, -> (start_date, end_date){
    where('sales_orders.created_at >= ? AND sales_orders.created_at <= ?', start_date, end_date)
  }
end
