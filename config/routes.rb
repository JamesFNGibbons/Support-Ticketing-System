Rails.application.routes.draw do
  root 'client#index'
  
  #/open-ticket
  get 'open-ticket' => 'client#open_ticket'
  
  #/login
  get 'login' => 'client#login'
  
  #/view-ticket
  get 'view-ticket' => 'client#view_ticket'
  #/close-ticket
  get 'close-ticket' => 'client#close_ticket'
  
end
