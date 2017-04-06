class Api::V1::EmploymentsController < Api::V1::BaseController
  def top_three_employees
    employees = []
    SalesItem.select('employment_id,
                      SUM(coalesce(paid_price, 0)) AS total_paid,
                      COUNT(id) AS total_services')
             .group('employment_id')
             .order('total_paid DESC')
             .limit(3).each do |row|
                employees << {
                  name: row.employment.name,
                  profit: row.total_paid.to_f,
                  services: row.total_services
                }
              end

    render json: { employees: employees }, status: :ok
  end
end