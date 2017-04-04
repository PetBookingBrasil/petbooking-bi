class Api::V1::EventsController < Api::V1::BaseController
  # Events in fact is the schedule event, when user schedule a service

  def today_and_average
    date         = Date.today - 1.month
    today_end    = date.end_of_day
    today_start  = date.beginning_of_day
    month_end    = date.end_of_month
    month_start  = date.beginning_of_month

    # Build the values for ONLINE events
    online = Event.online(true).between(today_start, today_end).count
    online_average = Event.online(true).between(month_start, month_end).count / 30
    online_hash = { total: online, average: online_average }

    # Build the values for OFFLINE events
    offline = Event.online(false).between(today_start, today_end).count
    offline_average = Event.online(false).between(month_start, month_end).count / 30
    offline_hash = { total: offline, average: offline_average }

    render json: { online: online_hash, offline: offline_hash }, status: :ok
  end

  def total_last_semester
    total = Event.count
    months = []

    6.times do |index|
      date  = Date.today - index.month
      month = Date::MONTHNAMES[date.month]
      count = Event.between(date.beginning_of_month, date.end_of_month).count
      # build a hash with months and their values
      months << { month: month, count: count }
    end

    render json: { total: total, months: months }, status: :ok
  end
end
