require 'fog/model'

module Fog
  module Terremark

    class Task < Fog::Model

      identity :id

      attribute :end_time,    'endTime'
      attribute :owner,       'Owner'
      attribute :result,      'Result'
      attribute :start_time,  'startTime'
      attribute :status

      def initialize(attributes = {})
        new_owner  = attributes.delete('Owner')
        new_result = attributes.delete('Result')
        super
        @owner  = connection.parse(new_owner)
        if new_result
          @result = connection.parse(new_result)
        end
      end

      def ready?
        @status == 'success'
      end

      private

      def href=(new_href)
        @id = new_href.split('/').last.to_i
      end

      def type=(new_type); end

    end

  end
end
