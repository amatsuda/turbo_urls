# config
ENV['DATABASE_URL'] = 'sqlite3::memory:'

module TurboUrlsTestApp
  class Application < Rails::Application
    config.secret_token = "My death waits there between your thighs
Your cool fingers will close my eyes
Let's think of that and the passing time"
    config.eager_load = false
    config.active_support.deprecation = :log
  end
  Application.initialize!
end

TurboUrlsTestApp::Application.routes.draw do
  resources :conferences, only: :index
  get 'null' => 'conferences#null'
  get 'one' => 'conferences#one'
end

# controllers
class ApplicationController < ActionController::Base
end

class ConferencesController < ApplicationController
  def null
    render text: ''
  end

  def one
    render text: conferences_path
  end
end
