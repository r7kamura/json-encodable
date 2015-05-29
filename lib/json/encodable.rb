require "active_support/concern"
require "active_support/core_ext/object/json"
require "active_support/json"
require "json/encodable/property"
require "json/encodable/version"

# Makes an included module encodable into JSON format by putting .as_json method.
#
# @example
#   class Blog
#     include JSON::Encodable
#
#     property :id
#     property :title
#     property :username
#
#     def id
#       1
#     end
#
#     def title
#       "wonderland"
#     end
#
#     def username
#       "alice"
#     end
#   end
#
#   puts Blog.new.to_json
#   #=> {"id":1,"title":"wonderland","username":"alice"}
#
# You can pass :only and :except options to .to_json method.
#
# @example
#   puts Blog.new.to_json(only: [:id, :username])
#   #=> {"id":1,"username":"alice"}
#
#   puts Blog.new.to_json(except: [:username])
#   #=> {"id":1,"title":"wonderland"}
#
module JSON
  module Encodable
    extend ActiveSupport::Concern

    # @return [Hash] An object representation of its properties.
    # @example
    #   {
    #     id: 1,
    #     title: "wonderland",
    #     username: "alice",
    #   }
    def as_json(options = {})
      properties(options).as_json(options)
    end

    private

    # @note All Time values will be encoded in ISO 8601 format
    # @param options [Hash] Options for .property_names method
    # @option options [Symbol, Array<Symbol>] :except Property names to exclude properties
    # @option options [Symbol, Array<Symbol>] :only Property names to filter properties
    # @return [Hash{Symbol => Object}] Properties as a key-value pairs Hash
    # @example
    #   {
    #     id: 1,
    #     title: "wonderland",
    #     username: "alice",
    #     created_at: "2014-07-11T11:28:54+09:00",
    #   }
    def properties(options = {})
      names = self.class.property_names
      names = names - Array(options[:except]) if options[:except]
      names = names & Array(options[:only]) if options[:only]
      names.inject({}) do |hash, property_name|
        key = property_name
        value = send(property_name)
        value = value.iso8601 if value.is_a?(Time)
        hash.merge(key => value)
      end
    end

    module ClassMethods
      attr_writer :property_names

      # @return [Array<Symbol>]
      def property_names
        properties.map(&:name)
      end

      # @return [Array<JSON::Encodable::Property>]
      def properties
        @properties ||= []
      end

      # @param [Symbol] property_name
      def property(property_name, options = {})
        properties << ::JSON::Encodable::Property.new(property_name, options)
      end

      # @note Override
      def inherited(child)
        super
        child.properties = properties.clone
      end
    end
  end
end
