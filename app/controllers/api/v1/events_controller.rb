class Api::V1::EventsController < Api::V1::BaseController
  # Events in fact is the schedule event, when user schedule a service

  def today_and_average
    today_end    = Date.today.end_of_day
    today_start  = Date.today.beginning_of_day
    month_end    = Date.today.end_of_month - 1.month
    month_start  = Date.today.beginning_of_month - 1.month

    # Build the values for ONLINE events
    online = Event.online(true).between(today_start, today_end).count
    online_average = Event.online(true).between(month_start, month_end).count / 30.0
    online_hash = { total: online, average: online_average.ceil }

    # Build the values for OFFLINE events
    offline = Event.online(false).between(today_start, today_end).count
    offline_average = Event.online(false).between(month_start, month_end).count / 30.0
    offline_hash = { total: offline, average: offline_average.ceil }

    render json: { online: online_hash, offline: offline_hash }, status: :ok
  end

  def total_last_semester
    total = 0
    months = []

    6.times do |index|
      # index+1 prevents from getting the current month
      date = Date.today - (index+1).month
      online = Event.online(true).between(date.beginning_of_month, date.end_of_month).count
      offline = Event.online(false).between(date.beginning_of_month, date.end_of_month).count
      # Total of events for this 6 months
      total += online + offline
      # Build the hash for each month
      months << { month: I18n.l(date, format: "%B"),
                  online: online, offline: offline }
    end

    render json: { total: total, months: months.reverse }, status: :ok
  end
end
