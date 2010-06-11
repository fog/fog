module Fog
  module Errors

    class Error < StandardError
      attr_accessor :verbose
    end

    class MockNotImplemented < Fog::Errors::Error; end

    class NotFound < Fog::Errors::Error; end

  end
end