Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  post 'auth_test', format: :json, to: 'api_v1#auth_test'

  get 'dmp_index_test', format: :json, to: 'api_v1#dmps_test'
  get 'dmp_show_test', format: :json, to: 'api_v1#dmp_test'

  post 'dmp_create_test', format: :json, to: 'api_v1#dmp_create_test'

end
