Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      root to: 'base#homepage'

      resources :users do
        collection do
          get 'active_today'
          get 'total_since_launch'
        end
      end
    end
  end
end
