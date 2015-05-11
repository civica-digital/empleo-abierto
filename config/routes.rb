Rails.application.routes.draw do
  
  #Here we map the different URLs with their respective routes
  get 'results/index' => 'results#index'
  get 'results/search' => 'results#search'

  #The index action of the results controller is the root of our application
  root 'results#index'

end
