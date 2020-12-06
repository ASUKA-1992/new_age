Rails.application.routes.draw do
  root "ten_years#index"

  resources :top do
  end

  resources :members do
    collection do
      get :login
      get :get_show_csv
      get :unsbscribe
      get :password_reset
    end
  end

  resources :consts do
  end

  resources :ages do
  end

  resources :prefectures do
  end

  resource :session, only: [:create, :destroy]

  resources :events do
    collection do
      get :year_new
      post :year_create
      get :destroy_all
      get :search
      get :set_mamber_filter
      get :restor_default
    end
  end

  resources :event_ages do
  end

  resources :event_prefectures do
  end

  resources :event_year_ages do
  end

  resources :csvs do
    collection do
      get :make_csv
      get :search
      get :set_target_csv
      get :delete_target_csv
      get :color_change
      get :show_data
      get :stop_open
    end
  end

  resources :ten_years do
    collection do
      get :login # ログイン画面
      get :detail
      get :manual
    end
  end

  resources :admins do
    collection do
      get :login # ログイン画面
    end
  end

  resources :session_admins, only: [:create, :destroy]
end
