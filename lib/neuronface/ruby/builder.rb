# frozen_string_literal: true

module Neuronface
  module Ruby
    module Builder
      class << self
        %i[layer kernel_initializer optimizer loss transfer].each do |symbol|
          define_method(symbol) do |type, *args|
            if type.is_a?(Hash)
              type = type.keys.first.tap do |k|
                args << type[k]
              end
            end
            resolve_class("Neuronface::Ruby::#{identifier_to_class(symbol)}", type)&.new(*args)
          end
        end

        def resolve_class(base, type)
          return if type.nil?

          Object.const_get("#{base}::#{identifier_to_class(type)}")
        end

        def identifier_to_class(id)
          id.to_s.split("_").map!(&:capitalize).join
        end
      end
    end
  end
end
