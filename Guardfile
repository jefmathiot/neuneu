# frozen_string_literal: true

guard :minitest do
  watch(%r{^test/(.*)_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})         { |m| "test/#{m[1]}_spec.rb" }
  watch(%r{^test/test_helper\.rb$}) { "spec" }
end
