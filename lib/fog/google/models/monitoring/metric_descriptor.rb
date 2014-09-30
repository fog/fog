require 'fog/core/model'

module Fog
  module Google
    class Monitoring
      ##
      # A metricDescriptor defines the name, label keys, and data type of a particular metric.
      #
      # @see https://developers.google.com/cloud-monitoring/v2beta1/metricDescriptors
      class MetricDescriptor < Fog::Model
        identity :name

        attribute :description
        attribute :labels
        attribute :project
        attribute :type_descriptor, :aliases => 'typeDescriptor'
      end
    end
  end
end
