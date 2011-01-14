require 'fog/core/collection'
require 'fog/compute/models/aws/volume'

module Fog
  module AWS
    class Compute

      class Volumes < Fog::Collection

        attribute :filters
        attribute :server

        model Fog::AWS::Compute::Volume

        # Used to create a volume.  There are 3 arguments and availability_zone and size are required.  You can generate a new key_pair as follows:
        # AWS.volumes.create(:availability_zone => 'us-east-1a', :size => 't1.micro')
        #
        # ==== Returns
        #
        #<Fog::AWS::Compute::Volume
        #  id="vol-1e2028b9",
        #  attached_at=nil,
        #  availability_zone="us-east-1a",
        #  created_at=Tue Nov 23 23:30:29 -0500 2010,
        #  delete_on_termination=nil,
        #  device=nil,
        #  server_id=nil,
        #  size="t1.micro",
        #  snapshot_id=nil,
        #  state="creating",
        #  tags=nil
        #>
        #
        # The volume can be retreived by running AWS.volumes.get("vol-1e2028b9").  See get method below.
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Used to return all volumes.
        # AWS.volumes.all
        #
        # ==== Returns
        #
        #>>AWS.volumes.all
        #<Fog::AWS::Compute::Volume
        #  id="vol-1e2028b9",
        #  attached_at=nil,
        #  availability_zone="us-east-1a",
        #  created_at=Tue Nov 23 23:30:29 -0500 2010,
        #  delete_on_termination=nil,
        #  device=nil,
        #  server_id=nil,
        #  size="t1.micro",
        #  snapshot_id=nil,
        #  state="creating",
        #  tags=nil
        #>
        #
        # The volume can be retreived by running AWS.volumes.get("vol-1e2028b9").  See get method below.
        #

        def all(filters = filters)
          unless filters.is_a?(Hash)
            Formatador.display_line("[yellow][WARN] all with #{filters.class} param is deprecated, use all('volume-id' => []) instead[/] [light_black](#{caller.first})[/]")
            filters = {'volume-id' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_volumes(filters).body
          load(data['volumeSet'])
          if server
            self.replace(self.select {|volume| volume.server_id == server.id})
          end
          self
        end

        # Used to retreive a volume
        # volume_id is required to get the associated volume information.
        #
        # You can run the following command to get the details:
        # AWS.volumes.get("vol-1e2028b9")
        #
        # ==== Returns
        #
        #>> AWS.volumes.get("vol-1e2028b9")
        # <Fog::AWS::Compute::Volume
        #    id="vol-1e2028b9",
        #    attached_at=nil,
        #    availability_zone="us-east-1a",
        #    created_at=Tue Nov 23 23:30:29 -0500 2010,
        #    delete_on_termination=nil,
        #    device=nil,
        #    server_id=nil,
        #    size="t1.micro",
        #    snapshot_id=nil,
        #    state="available",
        #    tags={}
        #  >
        #

        def get(volume_id)
          if volume_id
            self.class.new(:connection => connection).all('volume-id' => volume_id).first
          end
        end

        def new(attributes = {})
          if server
            super({ :server => server }.merge!(attributes))
          else
            super
          end
        end

      end

    end
  end
end
