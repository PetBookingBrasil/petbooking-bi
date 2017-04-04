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
          get 'active_current_month'
          get 'active_last_semester'
        end
      end
    end
  end
end
