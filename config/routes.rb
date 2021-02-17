Rails.application.routes.draw do
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :passwords => 'passwords', confirmations: 'confirmations', sessions: "sessions"  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    root to: "devise/sessions#new"
  end

  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          put :update_password
          put :update_user_skills
          get :get_user_services
          get :get_user_availed_services
          post :add_working_days
          get :get_user_events
          put :add_stripe_token
          get :recent_payouts
          get :total_earning
          post :payout
          get :get_bank_info
          get :get_unreviewed_events
          get :user_event_reviews
          post :contact_as
        end
        collection do
          put :forgot_password
          post :facebook_auth
          get :get_skilled_data
          get :search
        end
      end
      resources :sessions
      resources :service_categories
      resources :comments
      resources :appointments
      resources :endorsements do
        collection do
          put :un_endorse
        end
      end
      resources :user_connections do
        collection do
          get :get_connection_requests
          get :get_all_my_approved_connection_list
          get :get_connection_requests_new
          put :remove_connection
          get :connection_requests
        end
      end
      resources :working_days
      resources :reviews
      resources :services do
        member do
          get :check_available_slots_on
          get :service_reviews
        end
        collection do
          get :search
        end
      end
      resources :posts do
        member do
          post :like_post
          put  :share_post
          put  :repost
          get  :post_reactions
          post  :report_post
        end
        collection do

        end
      end
      resources :events do
        collection do
          get :search
        end
        member do
          get :get_attendees
          get :event_reviews
          post :charge_event
        end
      end
      resources :saved_events, only: [:create, :index] do
        collection do
          post :unsave
          get :services
        end
      end
      resources :tickets, only: [:index, :create, :show, :update]
      resources :messages, only: :create
      resources :chats, only: [:create, :index]
    end
  end

  resources :users
  resources :home do
    collection do
      get :user_after_confirmation
      post :users_report
      post :posts_report
      post :services_report
      get :chat_room
    end
  end
  resources :categories
  resources :skills
  resources :sub_skills
  resources :events do
    collection do
      get :register
    end
  end
  resources :appointments
  resources :services
  resources :payments
  resources :outgoing_payments
  resources :charges do
    collection do
      post :charge_new_user_for_event
      get  :validate_tickets_count
    end
  end
  resources :posts
  resources :report_posts
  get  "registration" => "charges#registration"

  get '*path' => 'home#handle_no_rout'

  # mount ActionCable.server => '/cable'
end

