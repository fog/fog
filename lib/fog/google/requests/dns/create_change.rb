module Fog
  module DNS
    class Google
      ##
      # Atomically updates a ResourceRecordSet collection.
      #
      # @see https://cloud.google.com/dns/api/v1beta1/changes/create
      class Real
        def create_change(zone_name_or_id, additions = [], deletions = [])
          api_method = @dns.changes.create
          parameters = {
            'project' => @project,
            'managedZone' => zone_name_or_id,
          }

          body = {
            'additions' => additions,
            'deletions' => deletions,
          }

          request(api_method, parameters, body)
        end
      end

      class Mock
        def create_change(zone_name_or_id, additions = [], deletions = [])
          if self.data[:managed_zones].has_key?(zone_name_or_id)
            zone = self.data[:managed_zones][zone_name_or_id]
          else
            zone = self.data[:managed_zones].values.find { |zone| zone['name'] = zone_name_or_id }
          end

          unless zone
            raise Fog::Errors::NotFound, "The 'parameters.managedZone' resource named '#{zone_name_or_id}' does not exist."
          end

          deletions.each do |del|
            rrset = self.data[:resource_record_sets][zone['id']].reject! { |r| r['name'] == del['name'] && r['type'] == del['type'] }
            unless rrset
              raise Fog::Errors::NotFound, "The 'entity.change.deletions[0]' resource named '#{del['name']} ('#{del['type']})' does not exist."
            end
          end

          additions.each do |add|
            self.data[:resource_record_sets][zone['id']] << add
          end

          id = self.data[:changes][zone['id']].max_by { |c| c['id'] }['id']
          data = {
            'kind' => 'dns#change',
            'id' => (id.to_i + 1).to_s,
            'startTime' => DateTime.now.strftime('%FT%T.%LZ'),
            'status' => 'done',
            'additions' => additions,
            'deletions' => deletions,
          }
          self.data[:changes][zone['id']] << data

          build_excon_response(data)
        end
      end
    end
  end
end
