# frozen_string_literal: true

module Neuronface
  module Ruby
    module Builder
      class << self
        def layer(type, *args, **kwargs)
          resolve_class("Neuronface::Ruby::Layer", type)&.new(*args, **kwargs)
        end

        %i[kernel_initializer optimizer loss transfer].each do |symbol|
          define_method(symbol) do |*args, **kwargs|
            if kwargs.keys.any?
              type = kwargs.keys.first
              kwargs = kwargs[type]
            else
              type = args.shift
            end
            resolve_class("Neuronface::Ruby::#{identifier_to_class(symbol)}", type)&.new(*args, **kwargs)
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
