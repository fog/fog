require 'fog/core/collection'
require 'fog/aws/models/compute/snapshot'

module Fog
  module AWS
    class Compute

      class Snapshots < Fog::Collection

        attribute :filters
        attribute :volume

        model Fog::AWS::Compute::Snapshot

        def initialize(attributes)
          @filters ||= { 'RestorableBy' => 'self' }
          super
        end

        def all(filters = @filters, options = {})
          unless options.empty?
            Formatador.display_line("[yellow][WARN] describe_snapshots with a second param is deprecated, use describe_snapshots(options) instead[/] [light_black](#{caller.first})[/]")
            filters.merge!(options)
          end
          data = connection.describe_snapshots(filters.merge!(options)).body
          load(data['snapshotSet'])
          if volume
            self.replace(self.select {|snapshot| snapshot.volume_id == volume.id})
          end
          self
        end

        def get(snapshot_id)
          if snapshot_id
            self.class.new(:connection => connection).all('snapshot-id' => snapshot_id).first
          end
        end

        def new(attributes = {})
          if volume
            super({ 'volumeId' => volume.id }.merge!(attributes))
          else
            super
          end
        end

      end

    end
  end
end
