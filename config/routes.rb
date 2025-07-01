# config/routes.rb
Rails.application.routes.draw do
  resources :articles do
    resources :comments, only: [:index, :create, :update, :destroy]
    resources :photos, only: [:create, :destroy]
  end
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
end