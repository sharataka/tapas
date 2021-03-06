Tapas::Application.routes.draw do


  resources :questions
  resources :lessons
  resources :questiontolessons
  resources :userstats
  resources :topics
  resources :lesson_feedbacks


  root :to => "questions#landing_page" 

  # STATIC PAGES

  # Dashboard
  match "/dashboard" => "questions#index"

  # About us
  match "/about"     => "questions#about"

  devise_for :users
  match "/review/session/:session_id/answers/:question_id" => "questions#review_answer"
  match "/review/all" => "questions#review_all"
  

  match "/admin" => "questions#admin"

  match "/custom_practice" => "questions#custom_practice"
  match "/custom_practice/:error" => "questions#custom_practice"


  match "/decide_start_session" => "questions#decide_start_session"
  match "/nextquestion" => "questions#nextquestion"

  match "/session/:session_id/question/:question_id/subject/:subject/pool/:questionpool" => "questions#session_question"
  match "/session/:session_id/answers/:question_id/order/:order/subject/:subject/pool/:questionpool" => "questions#answer"

  match "/review/:session_id" => "questions#review"
  match "/review/session/:session_id/answers/:question_id" => "questions#review_answer"


  # Lesson feedback
  match "/lesson_feedback/lesson/:lesson_id/feedback/:feedback" => "lesson_feedbacks#custom_feedback"

  # User understands lesson
  match "/understand_lesson/lesson/:lesson_id/user/:user_id" => "lesson_feedbacks#understand_lesson"

  match "/resetforadmin" => "questions#adminreset"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
