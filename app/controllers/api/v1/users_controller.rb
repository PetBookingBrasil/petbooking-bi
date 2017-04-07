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

    render json: { today: today, average: average }, status: :ok
  end

  def top_three_customers
    users = []
    SalesOrder.joins(:sales_items)
              .paid
              .select('sales_orders.clientship_id,
                       SUM(coalesce(sales_items.paid_price, 0)) AS total_paid,
                       COUNT(coalesce(sales_items.id)) AS total_events')
              .group('sales_orders.clientship_id')
              .order('total_paid desc')
              .limit(10).map do |row|
                if user = User.find_by(id: row.clientship_id)
                  users << {
                    name: user.name,
                    purchases: row.total_events,
                    address: user.city,
                    total: row.total_paid.to_f
                  }
                end
              end

    render json: { users: users }, status: :ok
  end

  def active_current_month
    date = Date.today
    total = User.active.count
    month = User.between(date.beginning_of_month, date.end_of_month).count

    render json: { total: total, month: month }, status: :ok
  end

  def passive_current_month
    date = Date.today
    total = User.passive.count
    month = User.between(date.beginning_of_month, date.end_of_month).count

    render json: { total: total, month: month }, status: :ok
  end
end
