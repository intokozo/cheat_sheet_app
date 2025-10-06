Rails.application.routes.draw do
  root to: "sections#index"

  resources :sections do
    resources :children, controller: "sections", only: [ :new, :create ]
    resources :articles
  end

  # Добавляем отдельный маршрут для всех статей
  resources :articles, only: [ :index ]
end
