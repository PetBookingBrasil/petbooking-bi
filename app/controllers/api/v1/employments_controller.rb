class Api::V1::EmploymentsController < Api::V1::BaseController
  def top_three_employees
    employees = []
    SalesItem.joins(:sales_order, :employment)
             .select('employment_id,
                      SUM(coalesce(paid_price, 0)) AS total_paid,
                      COUNT(sales_items.id) AS total_services')
             .where('sales_orders.aasm_state = 3
                     AND employments.business_id NOT IN (30, 36)')
             .group('employment_id')
             .order('total_paid DESC')
             .limit(10).each do |row|
                next if row.employment.blank?
                employees << {
                  name: row.employment.name,
                  profit: row.total_paid.to_f,
                  services: row.total_services,
                  business_id: row.employment.business_id,
                  business_slug: row.employment.business.slug
                }
              end

    render json: { employees: employees }, status: :ok
  end
end
