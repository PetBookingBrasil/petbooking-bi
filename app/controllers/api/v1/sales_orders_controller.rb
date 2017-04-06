class Api::V1::SalesOrdersController < Api::V1::BaseController
  def today
    start_date  = Date.today.beginning_of_day
    end_date    = Date.today.end_of_day
    # Last 30 days but not include the current day
    start_month = (Date.today - 31.days)
    end_month   = (Date.today - 1.day)

    # Calculate the Budget for today
    today = SalesOrder.joins(:sales_items)
                      .paid
                      .between(start_date, end_date)
                      .pluck('sales_items.unit_price').sum.to_f

    # Calculate the monthly average
    average = SalesOrder.joins(:sales_items)
                        .paid
                        .between(start_month, end_month)
                        .pluck('sales_items.unit_price').sum.to_f / 30.0

    render json: { today: today, average: average }, status: :ok
  end

  def total_last_year
    start_month = Date.today.beginning_of_month
    end_month   = Date.today.end_of_month
    # Get the value for current month
    current = SalesOrder.joins(:sales_items)
                        .paid
                        .online(true)
                        .between(start_month, end_month)
                        .pluck('sales_items.unit_price').sum.to_f

    months = []

    12.times do |index|
      date  = Date.today - (index+1).month
      month = Date::MONTHNAMES[date.month]
      total = SalesOrder.joins(:sales_items)
                        .paid
                        .online(true)
                        .between(date.beginning_of_month, date.end_of_month)
                        .pluck('sales_items.unit_price').sum.to_f
      # build a hash with months and their values
      months << { month: month, total: total }
    end

    render json: { current_month: current, months: months }, status: :ok
  end

  def top_online_services
    services = []
    top_10_amount = 0
    # Calculate the total amount paid for services
    total_in_services = SalesOrder.joins(:sales_items)
                        .paid
                        .online(true)
                        .pluck('sales_items.unit_price').sum.to_f

    # Now calculate the Top 10
    SalesOrder.joins(:sales_items)
              .online(true)
              .paid
              .select('sales_items.name,
                       SUM(coalesce(sales_items.paid_price, 0)) AS sales_item_total')
              .group('sales_items.name')
              .order('sales_item_total DESC')
              .limit(10)
              .each do |row|
                top_10_amount += row.sales_item_total
                services << { service: row.name, total: row.sales_item_total.to_f }
              end

    # Now use the partial value calculated to build "Others" service amount
    services << { service: 'Outros', total: (total_in_services - top_10_amount).to_f }

    render json: { services: services }, status: :ok
  end

  def top_offline_services
    services = []
    top_10_amount = 0
    # Calculate the total amount paid for services
    total_in_services = SalesOrder.joins(:sales_items)
                        .paid
                        .online(false)
                        .pluck('sales_items.unit_price').sum.to_f

    # Now calculate the Top 10
    SalesOrder.joins(:sales_items)
              .online(false)
              .paid
              .select('sales_items.name,
                       SUM(coalesce(sales_items.paid_price, 0)) AS sales_item_total')
              .group('sales_items.name')
              .order('sales_item_total DESC')
              .limit(10)
              .each do |row|
                top_10_amount += row.sales_item_total
                services << { service: row.name, total: row.sales_item_total.to_f }
              end

    # Now use the partial value calculated to build "Others" service amount
    services << { service: 'Outros', total: (total_in_services - top_10_amount).to_f }

    render json: { services: services }, status: :ok
  end
end
