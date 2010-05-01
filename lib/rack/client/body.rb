module Rack
  module Client
    module Parser
      class Body < Array

        def initialize(&proc)
          @proc = proc
        end
      end
    end
  end
end
