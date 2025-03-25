# config/routes.rb
Rails.application.routes.draw do
  resources :beverages
  root 'beverages#index'
end