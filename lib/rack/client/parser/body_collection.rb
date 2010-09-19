module Rack
  module Client
    class BodyCollection
      instance_methods.each { |m| undef_method m unless (m =~ /^__/ || m =~ /^object_id$/ ) }

      def initialize(&load_with_proc)
        raise ArgumentException, 'BodyCollection must be initialized with a block' unless block_given?

        @loaded         = false
        @finished       = false
        @load_with_proc = load_with_proc
        @callbacks      = []
        @array          = []
      end

      def each(&block)
        @callbacks << block
        @array.each {|a| yield(*a) }

        lazy_load unless finished?
      ensure
        @callbacks.delete(block)
      end

      def lazy_load
        until finished?
          @load_with_proc[self]
        end
      end

      def <<(value)
        @array << value
        @callbacks.each {|cb| cb[value] }
      end

      def finished?
        @finished
      end

      def finish
        @finished = true
      end

      def method_missing(sym, *a, &b)
        lazy_load
        @array.send(sym, *a, &b)
      end
    end
  end
end
