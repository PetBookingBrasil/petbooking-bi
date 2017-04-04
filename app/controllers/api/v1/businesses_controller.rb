class Api::V1::BusinessesController < Api::V1::BaseController
  def active_current_month
    date  = Date.today
    total = Business.active.count
    month = Business.active.between(date.beginning_of_month, date.end_of_month).count

    render json: { total: total, month: month }, status: :ok
  end

  def total_last_semester
    date       = Date.today
    end_date   = date.end_of_month
    start_date = date.beginning_of_month

    total   = Business.between(start_date, end_date).count
    average = Business.between(start_date - 6.months, end_date - 1.month).count / 6

    render json: { total: total, average: average }, status: :ok
  end

  def sign_up_progress
    results = []

    Business::AASM_STATES.each do |state|
      results << {
        step: state[0],
        count: Business.imported(false).by_step(state[1]).count
      }
    end

    render json: { steps: results }, status: :ok
  end
end
