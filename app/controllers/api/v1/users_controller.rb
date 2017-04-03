class Api::V1::UsersController < Api::V1::BaseController
  def total_since_launch
    total = User.count
    months = []

    12.times do |index|
      date  = Date.today - index.month
      month = Date::MONTHNAMES[date.month]
      count = User.between(date.beginning_of_month, date.end_of_month).count
      # build a hash with months and their values
      months << { month: month, count: count }
    end

    render json: { total: total, months: months }, status: :ok
  end

  def active_today
    date = Date.today
    today = User.active_today(date).count
    average = User.active_between(date - 30.days, date).count / 30

    render json: { today: today, average: average }
  end

  def active_current_month
    date = Date.today
    total = User.active.count
    month = User.between(date.beginning_of_month, date.end_of_month).count

    render json: { total: total, month: month }
  end

  def passive_current_month
    date = Date.today
    total = User.passive.count
    month = User.between(date.beginning_of_month, date.end_of_month).count

    render json: { total: total, month: month }
  end
end
