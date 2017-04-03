class Api::V1::UsersController < Api::V1::BaseController
  def total_since_launch
    total = User.count
    months = []

    # Build the hash with values
    12.times do |index|
      date = Date.today - index.month
      month = Date::MONTHNAMES[date.month]
      count = User.between(date.beginning_of_month, date.end_of_month)
      months << { month: month, count: count }
    end

    render json: { total: total, months: months }, status: :ok
  end
end
