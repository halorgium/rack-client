module Rack
  module Client
    module Parser
      class Context
        def initialize(app)
          @app = app
        end

        def call(env)
          Response.new(*@app.call(Request.new(env).env)).finish
        end
      end
    end
  end
end
