module Fog
  module Compute
    class Ecloud
      class TrustedNetworkGroup < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :hosts, :aliases => :Hosts

        def internet_services
          @internet_services ||= Fog::Compute::Ecloud::InternetServices.new(:connection => connection, :href => href)
        end

        def edit(options)
          options[:uri] = href
          data = connection.trusted_network_groups_edit(options).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end

        def delete
          data = connection.trusted_network_groups_delete(href).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
