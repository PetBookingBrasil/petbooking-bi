class Api::V1::BusinessesController < Api::V1::BaseController
  def active_current_month
    date  = Date.today
    total = Business.active.count
    month = Business.active.between(date.beginning_of_month, date.end_of_month).count

    render json: { total: total, month: month }, status: :ok
  end

  def schedulable_current_month
    date  = Date.today
    total = Business.active.imported(false).count
    month = Business.active.imported(false).between(date.beginning_of_month, date.end_of_month).count

    render json: { total: total, month: month }, status: :ok
  end

  def total_last_semester
    date       = Date.today
    end_date   = date.end_of_month
    start_date = date.beginning_of_month

    total   = Business.between(start_date, end_date).count
    average = Business.between(start_date - 6.months, end_date - 1.month).count.to_f / 6.0

    render json: { total: total, average: average.ceil }, status: :ok
  end

  def sign_up_progress
    results = []
    aasm_states = {
      wizard_0: 1, wizard_1: 2, wizard_2: 3, wizard_3: 4, wizard_4: 5,
      wizard_5: 6, wizard_6: 7, wizard_7: 8
    }

    aasm_states.each do |state|
      results << {
        step: state[0],
        count: Business.imported(false).by_step(state[1]).count
      }
    end

    render json: { steps: results }, status: :ok
  end

  def top_businesses_last_year
    limit = params[:limit] || 5
    amounts = []

    # Load the LIMIT businesses with more revenues on the last year.
    businesses_ids = SalesOrder.joins(:sales_items, :clientship)
              .where.not(aasm_state: 0)
              .between(Date.today - 1.year, Date.today)
              .by_businesses(business_ids)
              .select('clientships.business_id,
                       SUM(coalesce(sales_items.paid_price, 0)) AS total_paid,
                       COUNT(coalesce(sales_items.id)) AS total_events')
              .where('clientships.business_id NOT IN (30, 36)')
              .group('clientships.business_id')
              .order('total_paid desc')
              .limit(limit).map{|row| row.business_id}

      12.times do |i| #12
        date = Date.today - (i+1).month
        # Starting the search for month
        businesses_amounts = { month: "#{I18n.l(date, format: '%B')}" }
        businesses_ids.each_with_index do |business_id, index| #4
          #looking for amount for the current business and month
          # business = Business.find(business_id)
          amount = SalesOrder.joins(:clientship).where('clientships.business_id = ?', business_id)
                           .joins(:sales_items)
                           .between(date.beginning_of_month, date.end_of_month)
                           .sum('sales_items.unit_price').to_f
          businesses_amounts["#{index}"] = amount
        end
        amounts << businesses_amounts
      end

      render json: { amounts: amounts }, status: :ok
  end

  def top_businesses
    limit = params[:limit] || 10
    date = Date.today - 1.day
    businesses = []

    SalesOrder.joins(:sales_items, :clientship)
              .where.not(aasm_state: 0)
              .between(date - 30.days, date)
              .by_businesses(business_ids)
              .select('clientships.business_id,
                       SUM(coalesce(sales_items.paid_price, 0)) AS total_paid,
                       COUNT(coalesce(sales_items.id)) AS total_events')
              .where('clientships.business_id NOT IN (30, 36)')
              .group('clientships.business_id')
              .order('total_paid desc')
              .limit(limit).map do |row|
                if business = Business.find_by(id: row.business_id)
                  # Get the Reviews for this
                  reviews = Business.joins(:reviews)
                                    .where(id: row.business_id)
                                    .where('reviews.created_at >= ? AND reviews.created_at <= ?', date - 30.days, date)

                  # Get add services that aren't bath, leathering or veterinary consultations
                  others = SalesOrder.joins(:sales_items, :clientship)
                                     .where.not(aasm_state: 0)
                                     .between(date - 30.days, date)
                                     .where('clientships.business_id = ?', business.id)
                                     .where("name !~* 'banho' AND name !~* 'tosa' AND name !~* 'consulta veterinária'")
                                     .count('sales_items')

                  # Get all baths sold from this Business
                  baths = SalesOrder.joins(:sales_items, :clientship)
                                    .where.not(aasm_state: 0)
                                    .between(date - 30.days, date)
                                    .where('clientships.business_id = ?', business.id)
                                    .where("name ~* 'banho' AND name !~* 'tosa'")
                                    .count('sales_items')

                  # Get all leathering (Tosas) sold from this Business
                  leathering = SalesOrder.joins(:sales_items, :clientship)
                                         .where.not(aasm_state: 0)
                                         .between(date - 30.days, date)
                                         .where('clientships.business_id = ?', business.id)
                                         .where("name ~* 'tosa' AND name !~* 'banho'")
                                         .count('sales_items')

                  # Get all veterinary consultations from this business
                  veterinary_consultations = SalesOrder.joins(:sales_items, :clientship)
                                                       .where.not(aasm_state: 0)
                                                       .between(date - 30.days, date)
                                                       .where('clientships.business_id = ?', business.id)
                                                       .where("name ~* 'consulta veterinária'")
                                                       .count('sales_items')

                  # This is the response returned containing the infos
                  businesses << {
                    name: business.name,
                    sales: row.total_events,
                    address: business.city,
                    reviews: reviews.count,
                    reviews_average: reviews.average('reviews.business_rating').to_f || 0,
                    baths: baths,
                    others: others,
                    leathering: leathering,
                    veterinary_consultations: veterinary_consultations,
                    amount: row.total_paid.to_f
                  }
                end
              end

    render json: { businesses: businesses }, status: :ok
  end

  def total_business_clients
    total_women = Clientship.by_businesses(business_ids)
                            .joins(:user)
                            .where('users.gender = ?', 1)
                            .count

    total_men = Clientship.by_businesses(business_ids)
                          .joins(:user)
                          .where('users.gender = ?', 0)
                          .count

    total_undefined = Clientship.by_businesses(business_ids)
                                .joins(:user)
                                .where('users.gender IS NULL')
                                .count

    total = total_women + total_men + total_undefined

    clients = [ {total: total},
      {label: 'Homens', value: total_men},
      {label: 'Mulheres', value: total_women},
      {label: 'Indefinido', value: total_undefined}]

    render json: { clients: clients }, status: :ok
  end

end
