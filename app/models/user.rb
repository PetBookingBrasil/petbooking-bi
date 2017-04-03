class User < ApplicationRecord
  scope :active, -> { where('last_sign_in_at IS NOT NULL').count }
  scope :passive, -> { where('last_sign_in_at IS NULL').count }
  scope :between, ->(start_date, end_date) {
    where('created_at >= ? AND created_at <= ?', start_date, end_date).count
  }
end
