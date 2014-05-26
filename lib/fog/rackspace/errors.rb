module Fog
  module Rackspace
    module Errors
      def self.included(mod)
        mod.class_eval <<-'EOS', __FILE__, __LINE__
          class NotFound < Fog::Service::NotFound
            attr_reader :region, :status_code, :transaction_id

            def to_s
              status = status_code ? "HTTP #{status_code}" : "HTTP <Unknown>"
              message = region ? "resource not found in #{region} region" : super
              "[#{status} | #{transaction_id}] #{message}"
            end

            def self.slurp(error, service=nil)
              exception = NotFound.new
              exception.instance_variable_set(:@region, service.region) if service && service.respond_to?(:region)
              exception.instance_variable_set(:@status_code, error.response.status) rescue nil
              exception.set_transaction_id(error, service)
              exception
            end

            def set_transaction_id(error, service)
              return unless service && service.respond_to?(:request_id_header) && error.response
              @transaction_id = error.response.headers[service.request_id_header]
            end

          end
        EOS
      end
    end
  end
end
