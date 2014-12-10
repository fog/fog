require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/data_point'

module Fog
  module Rackspace
    class Monitoring
      class DataPoints < Fog::Collection
        attribute :metric

        model Fog::Rackspace::Monitoring::DataPoint

        def all
          self.fetch(:resolution => :full)
        end

        # Fetch the datapoints for a metric
        # ==== Parameters
        #
        # * options<~Hash> - optional paramaters
        #   * from<~Integer> - timestamp in milliseconds
        #   * to<~Integer> - timestamp in milliseconds
        #   * points<~Integer> - Number of points to fetch
        #   * resolution<~String> - Should be one of :full, :min5, :min20, :min60, :min240, :min1440
        #   * select<~Array> - Should be an array of :average, :max, :min, :variance
        #
        # ==== Returns
        # * datapoints<~Fog::Rackspace::Monitoring::Datapoints>:
        def fetch(options={})
          requires :metric
          options[:from] ||= (Time.now.to_i * 1000) - (3600 * 1000)
          options[:to] ||= Time.now.to_i * 1000
          options[:points] ||= 1 unless options[:resolution]
          if options[:resolution]
            options[:resolution] = options[:resolution].upcase
          end
          data = service.list_data_points(metric.check.entity.id, metric.check.id, metric.name, options).body['values']
          load(data)
        end

        def new(attributes = {})
          requires :metric
          super({ :metric => metric }.merge!(attributes))
        end
      end
    end
  end
end
