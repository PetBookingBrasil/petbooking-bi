class User < ApplicationRecord
  scope :active, -> { where('last_sign_in_at IS NOT NULL') }
  scope :passive, -> { where('last_sign_in_at IS NULL') }
  scope :between, -> (start_date, end_date) {
    where('created_at >= ? AND created_at <= ?', start_date, end_date)
  }
  scope :active_today, -> (date) {
    active.
    where('last_sign_in_at >= ? AND last_sign_in_at <= ?',
      date.beginning_of_day, date.end_of_day)
  }

  scope :active_between, -> (start_date, end_date) {
    active.
    where('last_sign_in_at >= ? AND last_sign_in_at <= ?', start_date, end_date)
  }
end
