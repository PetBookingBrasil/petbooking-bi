class Api::V1::SalesOrdersController < Api::V1::BaseController
  def today
    start_date  = Date.today.beginning_of_day
    end_date    = Date.today.end_of_day
    # Last 30 days but not include the current day
    start_month = (Date.today - 31.days)
    end_month   = (Date.today - 1.day)

    # Calculate the Budget for today online sales
    today_online = SalesOrder.joins(:sales_items)
                             .where.not(aasm_state: 0).online(true)
                             .between(start_date, end_date)
                             .pluck('sales_items.unit_price').sum.to_f

    # Calculate the monthly average online sales
    average_online = SalesOrder.joins(:sales_items)
                               .where.not(aasm_state: 0).online(true)
                               .between(start_month, end_month)
                               .pluck('sales_items.unit_price').sum.to_f / 30.0

    # Calculate the Budget for today offline sales
    today_offline = SalesOrder.joins(:sales_items)
                              .where.not(aasm_state: 0).online(false)
                              .between(start_date, end_date)
                              .pluck('sales_items.unit_price').sum.to_f

    # Calculate the monthly average offline sales
    average_offline = SalesOrder.joins(:sales_items)
                                .where.not(aasm_state: 0).online(false)
                                .between(start_month, end_month)
                                .pluck('sales_items.unit_price').sum.to_f / 30.0

    render json: { today_online: today_online, average_online: average_online,
                   today_offline: today_offline, average_offline: average_offline },
           status: :ok
  end

  def total_last_year
    months = []
    start_month = Date.today.beginning_of_month
    end_month   = Date.today.end_of_month

    # Get the value for current month
    current = SalesOrder.joins(:sales_items)
                        .where.not(aasm_state: 0)
                        .online(true)
                        .between(start_month, end_month)
                        .pluck('sales_items.unit_price').sum.to_f


    12.times do |index|
      # index+1 prevents from getting the current month
      # Total sales online
      date  = Date.today - (index+1).month
      online = SalesOrder.joins(:sales_items)
                        .paid
                        .online(true)
                        .between(date.beginning_of_month, date.end_of_month)
                        .sum('sales_items.unit_price').to_f

      # Total sales offline
      offline = SalesOrder.joins(:sales_items)
                          .where.not(aasm_state: 0)
                          .online(false)
                          .between(date.beginning_of_month, date.end_of_month)
                          .sum('sales_items.unit_price').to_f

      # build a hash with months and their values
      months << { month: I18n.l(date, format: "%B"), online: online, offline: offline }
    end

    render json: { current_month: current, months: months.reverse }, status: :ok
  end

  def top_online_services
    services = []
    start_month = (Date.today - 31.days)
    end_month   = (Date.today - 1.day)
    top_10_amount = 0
    # Calculate the total amount paid for services
    total_in_services = SalesOrder.joins(:sales_items)
                                  .where.not(aasm_state: 0)
                                  .between(start_month, end_month)
                                  .online(true)
                                  .sum('sales_items.unit_price').to_f

    # Now calculate the Top 10
    SalesOrder.joins(:sales_items)
              .online(true)
              .where.not(aasm_state: 0)
              .between(start_month, end_month)
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
    start_month = (Date.today - 31.days)
    end_month   = (Date.today - 1.day)
    top_10_amount = 0
    # Calculate the total amount paid for services
    total_in_services = SalesOrder.joins(:sales_items)
                        .where.not(aasm_state: 0)
                        .between(start_month, end_month)
                        .online(false)
                        .sum('sales_items.unit_price').to_f

    # Now calculate the Top 10
    SalesOrder.joins(:sales_items)
              .online(false)
              .where.not(aasm_state: 0)
              .between(start_month, end_month)
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

  def by_week_days
    online = []
    offline = []

    # First calculate for Online timeslots
    SalesOrder.paid
              .online(true)
              .joins(:timeslots)
              .select("count(*) services, extract(DOW from timeslots.starts_at) AS day_of_week")
              .order('services DESC')
              .group('day_of_week')
              .each do |row|
                online << { day: I18n.t('date.day_names')[row.day_of_week], services: row.services }
              end

    # First calculate for Offline timeslots
    SalesOrder.paid
              .online(false)
              .joins(:timeslots)
              .select("count(*) services, extract(DOW from timeslots.starts_at) AS day_of_week")
              .order('services DESC')
              .group('day_of_week')
              .each do |row|
                offline << { day:I18n.t('date.day_names')[row.day_of_week], services: row.services }
              end

    render json: { online: online, offline: offline }
  end
end
