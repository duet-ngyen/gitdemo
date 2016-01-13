Rails.application.routes.draw do

  resources :documents do
    resources :revisions do
      resources :compares
    end
  end
  root "documents#index"
end
