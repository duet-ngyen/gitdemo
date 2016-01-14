Rails.application.routes.draw do

  resources :documents do
    resources :revisions do
      resources :compares
    end
    collection {get :restore}
  end
  root "documents#index"
end
