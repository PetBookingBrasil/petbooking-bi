class Api::V1::UsersController < Api::V1::BaseController
  def total_since_launch
    total = User.count
    months = []

    # Count and build the hash for active users
    12.times do |index|
      # index+1 prevents from getting the current month
      date = Date.today - (index+1).month
      online = User.active.between(date.beginning_of_month, date.end_of_month).count
      offline = User.passive.between(date.beginning_of_month, date.end_of_month).count
      # build a hash with months and their values
      months << { month: I18n.l(date, format: "%B"), online: online, offline: offline }
    end

    render json: { total: total, months: months.reverse }, status: :ok
  end

  def active_today
    date = Date.today
    today = User.active_today(date).count
    average = User.active_between(date - 30.days, date).count.to_f / 30.0

    render json: { today: today, average: average.ceil }, status: :ok
  end

  def top_three_customers
    date  = Date.today - 1.day
    users = []

    SalesOrder.joins(:sales_items, :clientship)
              .paid
              .between(date - 30.days, date)
              .select('clientships.user_id,
                       SUM(coalesce(sales_items.paid_price, 0)) AS total_paid,
                       COUNT(coalesce(sales_items.id)) AS total_events')
              .group('clientships.user_id')
              .order('total_paid desc')
              .limit(10).map do |row|
                if user = User.find_by(id: row.user_id)
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
    month = User.active.between(date.beginning_of_month, date.end_of_month).count

    render json: { total: total, month: month }, status: :ok
  end

  def passive_current_month
    date = Date.today
    total = User.passive.count
    month = User.passive.between(date.beginning_of_month, date.end_of_month).count

    render json: { total: total, month: month }, status: :ok
  end

end
