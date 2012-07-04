require 'fog/core/collection'
require 'fog/aws/models/dns/record'

module Fog
  module DNS
    class AWS

      class Records < Fog::Collection

        attribute :is_truncated,            :aliases => ['IsTruncated']
        attribute :max_items,               :aliases => ['MaxItems']
        attribute :name
        attribute :next_record_name,        :aliases => ['NextRecordName']
        attribute :next_record_type,        :aliases => ['NextRecordType']
        attribute :next_record_identifier,  :aliases => ['NextRecordIdentifier']
        attribute :type
        attribute :identifier

        attribute :zone

        model Fog::DNS::AWS::Record

        def all(options = {})
          requires :zone
          options[:max_items]  ||= max_items
          options[:name]       ||= zone.domain
          options[:type]       ||= type
          options[:identifier] ||= identifier
          options.delete_if {|key, value| value.nil?}

          data = connection.list_resource_record_sets(zone.id, options).body
          # NextRecordIdentifier is completely absent instead of nil, so set to nil, or iteration breaks.
          data['NextRecordIdentifier'] = nil unless data.has_key?('NextRecordIdentifier')

          merge_attributes(data.reject {|key, value| !['IsTruncated', 'MaxItems', 'NextRecordName', 'NextRecordType', 'NextRecordIdentifier'].include?(key)})
          # leave out the default, read only records
          data = data['ResourceRecordSets'].reject {|record| ['NS', 'SOA'].include?(record['Type'])}
          load(data)
        end

        #
        # Load all zone records into the collection.
        #
        def all!
          data = []

          merge_attributes({'NextRecordName' => nil,
                            'NextRecordType' => nil,
                            'NextRecordIdentifier' => nil,
                            'IsTruncated' => nil})

          begin
            options = {
                :name => next_record_name,
                :type => next_record_type,
                :identifier => next_record_identifier
            }
            options.delete_if {|key, value| value.nil?}

            batch = connection.list_resource_record_sets(zone.id, options).body
            # NextRecordIdentifier is completely absent instead of nil, so set to nil, or iteration breaks.
            batch['NextRecordIdentifier'] = nil unless batch.has_key?('NextRecordIdentifier')

            merge_attributes(batch.reject {|key, value| !['IsTruncated', 'MaxItems', 'NextRecordName', 'NextRecordType', 'NextRecordIdentifier'].include?(key)})

            data.concat(batch['ResourceRecordSets'])
          end while is_truncated

          load(data)
        end

        #
        # AWS Route 53 records are uniquely identified by a compound key of name, type, and identifier.
        # #get allows one to retrieve a record using one or more of those key components.
        #
        # ==== Parameters
        # * record_name - The name of the record to retrieve.
        # * record_type - The type of record to retrieve, if nil, then the first matching record is returned.
        # * record_identifier - The record set identifier to retrieve, if nil, then the first matching record is returned.
        #
        def get(record_name, record_type = nil, record_identifier = nil)
          requires :zone
          # Append a trailing period to the record_name if absent.
          record_name = record_name + "." unless record_name.end_with?(".")
          record_type = record_type.upcase unless record_type.nil?

          options = {
              :max_items => 1,
              :name => record_name,
              :type => record_type,
              :identifier => record_identifier
          }
          options.delete_if {|key, value| value.nil?}

          data = connection.list_resource_record_sets(zone.id, options).body
          # Get first record
          data = data['ResourceRecordSets'].shift

          if data
            record = new(data)
            # make sure everything matches
            if record.name == record_name
              if (!record_type.nil? && record.type != record_type) ||
                  (!record_identifier.nil? && record.set_identifier != record_identifier)
                nil
              else
                record
              end
            end
          else
            nil
          end
        rescue Excon::Errors::NotFound
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
