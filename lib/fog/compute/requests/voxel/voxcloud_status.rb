module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_status( device_id = nil )
          options = { :verbosity => 'compact' }

          unless device_id.nil?
            options[:device_id] = device_id
          end

          data = request("voxel.voxcloud.status", options, Fog::Parsers::Voxel::Compute::VoxcloudStatus.new ).body

          if data[:stat] == 'fail'
            raise Fog::Voxel::Compute::NotFound
          else
            data[:devices]
          end
        end
      end

      class Mock
        def voxcloud_status( device_id = nil )
          @data[:statuses].each_pair do |id, status|
            if Time.now - @data[:last_modified][:statuses][id] > 2
              case status
              when "QUEUED"
                @data[:statuses][id] = "IN_PROGRESS"
                @data[:last_modified][:statuses][id] = Time.now
              when "IN_PROGRESS"
                @data[:statuses][id] = "SUCCEEDED"
                @data[:last_modified][:statuses][id] = Time.now
              end
            end
          end

         if device_id.nil?
            @data[:statuses].map { |status| { :id => status[0], :status => status[1] } }
          else
            if @data[:statuses].has_key?(device_id)
              [ { :id => device_id, :status => @data[:statuses][device_id] } ]
            else
              raise Fog::Voxel::Compute::NotFound
            end
          end
        end
      end
    end
  end
end
