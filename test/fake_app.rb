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
  resources :conferences, only: %i(index show)
  get 'null' => 'conferences#null'
  get 'one' => 'conferences#one'
  get 'integer_show' => 'conferences#integer_show'
  get 'string_show' => 'conferences#string_show'
  get 'model_path/:id' => 'conferences#model_path'
  get 'url_for_model/:id' => 'conferences#url_for_model'
end

# models
class Conference < ActiveRecord::Base; end

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

  def integer_show
    render text: conference_path(1)
  end

  def string_show
    render text: conference_path('2')
  end

  def model_path
    render text: conference_path(Conference.find(params[:id]))
  end

  def url_for_model
    render inline: "<%= link_to('Kaigi', Conference.find(params[:id])) %>"
  end
end


# migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:conferences) {|t| t.string :name}
  end
end
