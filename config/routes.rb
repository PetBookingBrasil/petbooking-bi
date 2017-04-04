Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      root to: 'base#homepage'

      resources :users do
        collection do
          get 'active_today'
          get 'total_since_launch'
          get 'active_current_month'
          get 'passive_current_month'
        end
      end

      resources :businesses do
        collection do
          get 'sign_up_progress'
          get 'total_last_semester'
          get 'active_current_month'
        end
      end

      resources :events do
        collection do
          get 'today_and_average'
          get 'total_last_semester'
        end
      end

      resources :sales_orders, path: 'sales' do
        collection do
          get 'today'
          get 'total_last_year'
        end
      end
    end
  end
end
