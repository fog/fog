require 'fog/core/collection'
require 'fog/dns/models/aws/record'

module Fog
  module AWS
    class DNS

      class Records < Fog::Collection

        attribute :is_truncated,      :aliases => ['IsTruncated']
        attribute :max_items,         :aliases => ['MaxItems']
        attribute :name
        attribute :next_record_name,  :aliases => ['NextRecordName']
        attribute :next_record_type,  :aliases => ['NextRecordType']
        attribute :type

        attribute :zone

        model Fog::AWS::DNS::Record

        def all(options = {})
          requires :zone
          options['MaxItems'] ||= max_items
          options['Name']     ||= name
          options['Type']     ||= type
          data = connection.list_resource_record_sets(zone.id, options).body
          merge_attributes(data.reject {|key, value| !['IsTruncated', 'MaxItems', 'NextRecordName', 'NextRecordType'].include?(key)})
          # leave out the default, read only records
          data = data['ResourceRecordSets'].reject {|record| ['NS', 'SOA'].include?(record['Type'])}
          load(data)
        end

        def get(record_id)
          data = connection.get_change(record_id).body
          new(data)
        rescue Excon::Errors::BadRequest
          nil
        end

        def new(attributes = {})
          requires :zone
          super({ :zone => zone }.merge!(attributes))
        end

      end

    end
  end
end
