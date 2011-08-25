require 'fog/core/model'
require 'fog/virtual_box/models/compute/medium_format'

module Fog
  module Compute
    class VirtualBox

      class Medium < Fog::Model

        identity :id

        attribute :auto_reset
        attribute :base
        attribute :children
        attribute :description
        attribute :device_type
        attribute :format
        attribute :host_drive
        attribute :id
        attribute :last_access_error
        attribute :location
        attribute :logical_size
        attribute :machine_ids
        attribute :medium_format
        attribute :name
        attribute :parent
        attribute :read_only
        attribute :size
        attribute :state
        attribute :type
        attribute :variant

        def destroy
          requires :raw
          raw.close
          true
        end

        undef_method :medium_format
        def medium_format
          Fog::Compute::VirtualBox::MediumFormat.new(
            :connection => connection,
            :raw        => raw.medium_format
          )
        end

        def save
          requires :device_type, :location, :read_only

          if File.exists?(location)

            access_mode = if read_only
              :access_mode_read_only
            else
              :access_mode_read_write
            end

            self.raw = connection.open_medium(location, device_type, access_mode)

          else

            raise Fog::Errors::Error.new('Creating a new medium is not yet implemented. Contributions welcome!')

          end
        end

        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw
          raw_attributes = {}
          for key in [:auto_reset, :base, :children, :description, :device_type, :format, :host_drive, :id, :last_access_error, :location, :logical_size, :machine_ids, :medium_format, :name, :parent, :read_only, :size, :state, :type, :variant]
            raw_attributes[key] = @raw.send(key)
          end
          merge_attributes(raw_attributes)
        end

      end

    end
  end

end
