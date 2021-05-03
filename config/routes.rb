Rails.application.routes.draw do
  mount GoodJob::Engine => 'good_job'

  resources :vehicles, only: %i[index destroy] do
    collection do
      get :import
      get :import_template
      post :process_import
    end
  end

  resources :reports, only: [] do
    collection do
      get :customers_by_nationality
      get :average_odometer_reading_by_nationality
    end
  end

  root 'vehicles#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
