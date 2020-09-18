require "rubygems"
require "sinatra"
require "json"

class App < Sinatra::Application

  set :bind, '0.0.0.0'

  get '/' do
    "<h1>My first Docker Test Sinatra app</h1>"
  end

  post '/json/?' do
    params.to_json
  end

end
