# == Route Map
#
#          Prefix Verb   URI Pattern                     Controller#Action
#      categories GET    /categories(.:format)           categories#index
#                 POST   /categories(.:format)           categories#create
#    new_category GET    /categories/new(.:format)       categories#new
#   edit_category GET    /categories/:id/edit(.:format)  categories#edit
#        category GET    /categories/:id(.:format)       categories#show
#                 PATCH  /categories/:id(.:format)       categories#update
#                 PUT    /categories/:id(.:format)       categories#update
#                 DELETE /categories/:id(.:format)       categories#destroy
#            pets GET    /pets(.:format)                 pets#index
#                 POST   /pets(.:format)                 pets#create
#         new_pet GET    /pets/new(.:format)             pets#new
#        edit_pet GET    /pets/:id/edit(.:format)        pets#edit
#             pet GET    /pets/:id(.:format)             pets#show
#                 PATCH  /pets/:id(.:format)             pets#update
#                 PUT    /pets/:id(.:format)             pets#update
#                 DELETE /pets/:id(.:format)             pets#destroy
#          orders GET    /orders(.:format)               orders#index
#                 POST   /orders(.:format)               orders#create
#       new_order GET    /orders/new(.:format)           orders#new
#      edit_order GET    /orders/:id/edit(.:format)      orders#edit
#           order GET    /orders/:id(.:format)           orders#show
#                 PATCH  /orders/:id(.:format)           orders#update
#                 PUT    /orders/:id(.:format)           orders#update
#                 DELETE /orders/:id(.:format)           orders#destroy
#     order_items GET    /order_items(.:format)          order_items#index
#                 POST   /order_items(.:format)          order_items#create
#  new_order_item GET    /order_items/new(.:format)      order_items#new
# edit_order_item GET    /order_items/:id/edit(.:format) order_items#edit
#      order_item GET    /order_items/:id(.:format)      order_items#show
#                 PATCH  /order_items/:id(.:format)      order_items#update
#                 PUT    /order_items/:id(.:format)      order_items#update
#                 DELETE /order_items/:id(.:format)      order_items#destroy
#        products GET    /products(.:format)             products#index
#                 POST   /products(.:format)             products#create
#     new_product GET    /products/new(.:format)         products#new
#    edit_product GET    /products/:id/edit(.:format)    products#edit
#         product GET    /products/:id(.:format)         products#show
#                 PATCH  /products/:id(.:format)         products#update
#                 PUT    /products/:id(.:format)         products#update
#                 DELETE /products/:id(.:format)         products#destroy
#           users GET    /users(.:format)                users#index
#                 POST   /users(.:format)                users#create
#        new_user GET    /users/new(.:format)            users#new
#       edit_user GET    /users/:id/edit(.:format)       users#edit
#            user GET    /users/:id(.:format)            users#show
#                 PATCH  /users/:id(.:format)            users#update
#                 PUT    /users/:id(.:format)            users#update
#                 DELETE /users/:id(.:format)            users#destroy

Rails.application.routes.draw do
  resources :products
  resources :order_items
  resources :orders 
  resources :pets
  resources :categories
  resources :users #, only: :create, :login, :index

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: :create do
    collection do
      post 'confirm'
      post 'login'
    end
  end

end
