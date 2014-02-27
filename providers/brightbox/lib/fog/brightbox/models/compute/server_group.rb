require 'fog/core/model'

module Fog
  module Compute
    class Brightbox
      # A server group is a collection of servers
      #
      # Certain actions can accept a server group and affect all members
      class ServerGroup < Fog::Model

        identity :id

        attribute :url
        attribute :resource_type
        attribute :name
        attribute :description
        attribute :default
        attribute :created_at, :type => :time

        attribute :server_ids, :aliases => "servers"

        def save
          options = {
            :name => name,
            :description => description
          }.delete_if { |k, v| v.nil? || v == "" }
          data = service.create_server_group(options)
          merge_attributes(data)
          true
        end

        def servers
          srv_ids = server_ids.map { |srv| srv["id"] }
          srv_ids.map do |srv_id|
            service.servers.get(srv_id)
          end
        end

        # Adds specified servers to this server group
        #
        # @param [Array] identifiers array of server identifier strings to add
        # @return [Fog::Compute::ServerGroup]
        def add_servers(identifiers)
          requires :identity
          options = {
            :servers => server_references(identifiers)
          }
          data = service.add_servers_server_group identity, options
          merge_attributes data
        end

        # Removes specified servers from this server group
        #
        # @param [Array] identifiers array of server identifier strings to remove
        # @return [Fog::Compute::ServerGroup]
        def remove_servers(identifiers)
          requires :identity
          options = {
            :servers => server_references(identifiers)
          }
          data = service.remove_servers_server_group identity, options
          merge_attributes data
        end

        # Moves specified servers from this server group to the specified destination server group
        #
        # @param [Array] identifiers array of server identifier strings to move
        # @param [String] destination_group_id destination server group identifier
        # @return [Fog::Compute::ServerGroup]
        def move_servers(identifiers, destination_group_id)
          requires :identity
          options = {
            :servers => server_references(identifiers),
            :destination => destination_group_id
          }
          data = service.move_servers_server_group identity, options
          merge_attributes data
        end

        def destroy
          requires :identity
          service.destroy_server_group(identity)
          true
        end

        protected

        def server_references(identifiers)
          identifiers.map { |id| { "server" => id } }
        end
      end
    end
  end
end
