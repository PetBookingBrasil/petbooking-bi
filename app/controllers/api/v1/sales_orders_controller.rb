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
end
