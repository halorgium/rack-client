require "rubygems"
require "rack"
require "sinatra/base"

module Demo
  Store = Hash.new

  class App < Sinatra::Base
    get "/store/:id" do
      if item = Store[ params[:id] ]
        item
      else
        status 404
        ""
      end
    end

    put "/store/:id" do
      Store[ params[:id] ] = request.body.read
    end

    delete "/store" do
      Store.clear
      ""
    end

    delete "/store/:id" do
      Store.delete params[:id]
    end
  end
end
