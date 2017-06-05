Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      root to: 'base#homepage'

      resources :users do
        collection do
          get 'active_today'
          get 'total_since_launch'
          get 'top_three_customers'
          get 'active_current_month'
          get 'passive_current_month'
        end
      end

      resources :businesses do
        collection do
          get 'top_businesses(/:limit)(/:business_id)',to: 'businesses#top_businesses'
          get 'sign_up_progress'
          get 'total_last_semester'
          get 'active_current_month'
          get 'schedulable_current_month'
          get 'total_business_clients(/:business_id)', to:'businesses#total_business_clients'
        end
      end

      resources :events do
        collection do
          get 'today_and_average(/:business_id)', to: 'events#today_and_average'
          get 'total_last_semester(/:business_id)', to: 'events#total_last_semester'
        end
      end

      resources :sales_orders, path: 'sales' do
        collection do
          get 'today(/:business_id)', to: 'sales_orders#today'
          get 'by_week_days'
          get 'total_last_year(/:business_id)', to: 'sales_orders#total_last_year'
          get 'top_online_services(/:business_id)', to: 'sales_orders#top_online_services'
          get 'top_offline_services(/:business_id)', to: 'sales_orders#top_offline_services'
        end
      end

      resources :employments do
        collection do
          get 'top_three_employees(/:business_id)', to: 'employments#top_employees'
          get 'top_employees(/:business_id)', to: 'employments#top_employees'
        end
      end
    end
  end
end
