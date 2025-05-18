Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :players, only: [:create] do
        resources :playthroughs, only: %i[index create]
      end
    end
  end

  namespace :api do
    namespace :v1 do
      get 'weekly_summary', to: 'weekly_summary#index'
      get 'impact_report', to: 'impact_report#index'
    end
  end
end
