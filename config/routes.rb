Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'requests#new'

  resource :request, only: %i[create new] do
    get :result
  end

  namespace :api do
    namespace :v1 do
      get '/best_deal', to: 'cats#best_deal'
    end
  end
end
