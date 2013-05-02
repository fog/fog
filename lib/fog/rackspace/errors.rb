module Fog
  module Rackspace
    module Errors

      def self.included(mod)
        mod.class_eval <<-'EOS', __FILE__, __LINE__
          class NotFound < Fog::Service::NotFound
            attr_reader :region, :status_code

            def to_s
              status = status_code ? "[HTTP #{status_code}] " : ""
              message = region ? "resource not found in #{region} region" : super
              "#{status}#{message}"
            end

            def self.slurp(error, region=nil)
              exception = NotFound.new
              exception.instance_variable_set(:@region, region)
              exception.instance_variable_set(:@status_code, error.response.status) rescue nil
              exception
            end
          end
        EOS
      end
    end
  end
end