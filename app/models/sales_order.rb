class SalesOrder < ApplicationRecord
  AASM_STATES = { cancelled: 0, open: 1, payment: 2, paid: 1 }

  has_many :sales_items, dependent: :destroy

  scope :paid, -> { where(aasm_state: AASM_STATES[:paid]) }
  scope :online, -> (boolean) { where(online: boolean) }
  scope :between, -> (start_date, end_date){
    where('sales_orders.created_at >= ? AND sales_orders.created_at <= ?', start_date, end_date)
  }
end
