Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  Rails.application.routes.draw do
    get '/test', to: 'test#heehaw'
  end
end
