module JSON
  module Encodable
    class Property
      # @return [Symbol]
      attr_reader :name

      # @return [Hash{Symbol => Object}]
      attr_reader :options

      # @param [Symbol] name
      # @param [Hash{Symbol => Object}] options
      def initialize(name, options = {})
        @name = name
        @options = options
      end
    end
  end
end
