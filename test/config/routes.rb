TurboUrlsTestApp::Application.routes.draw do
  resources :conferences, only: %i(index show)
  get 'null' => 'conferences#null'
  get 'one' => 'conferences#one'
  get 'integer_show' => 'conferences#integer_show'
  get 'string_show' => 'conferences#string_show'
  get 'model_path/:id' => 'conferences#model_path'
  get 'url_for_model/:id' => 'conferences#url_for_model'
end
