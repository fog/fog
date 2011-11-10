module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/event_list'

        # Returns a list of service events
        #
        # === Parameters (optional)
        # * options <~Hash> (optional):
        # *  :start_time <~DateTime> - starting time for event records
        # *  :end_time <~DateTime> - ending time for event records
        # *  :duration <~DateTime> - time span for event records
        # *  :marker <~String> - marker provided in the previous request
        # *  :max_records <~Integer> - the maximum number of records to include
        # *  :source_identifier <~DateTime> - identifier of the event source
        # *  :source_type <~DateTime> - event type, one of:
        #      (cache-cluster | cache-parameter-group | cache-security-group)
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def describe_events(options = {})
          request(
            'Action'            => 'DescribeEvents',
            'StartTime'         => options[:sart_time],
            'EndTime'           => options[:end_time],
            'Duration'          => options[:duration],
            'Marker'            => options[:marker],
            'MaxRecords'        => options[:max_records],
            'SourceIdentifier'  => options[:source_identifier],
            'SourceType'        => options[:source_type],
            :parser => Fog::Parsers::AWS::Elasticache::EventListParser.new
          )
        end

      end

      class Mock
        def describe_events
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
