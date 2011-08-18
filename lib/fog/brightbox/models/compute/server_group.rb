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

        def save
          requires :name
          options = {
            :name => name,
            :description => description
          }.delete_if {|k,v| v.nil? || v == "" }
          data = connection.create_server_group(options)
          merge_attributes(data)
          true
        end

        # Add a server to the server group
        #
        # == Parameters:
        # identifiers::
        #   An array of identifiers for the servers to add to the group
        #
        # == Returns:
        #
        # An excon response object representing the result
        #
        #  <Excon::Response: ...
        #
        def add_servers(server_identifiers)
          requires :identity
          server_references = server_identifiers.map {|ident| {"server" => ident} }
          options = {
            :servers => server_references
          }
          data = connection.add_servers_server_group(identity, options)
          merge_attributes(data)
        end

      end

    end
  end
end