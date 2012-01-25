require 'fog/core/collection'
require 'fog/libvirt/models/compute/server'

module Fog
  module Compute
    class Libvirt

      class Servers < Fog::Collection

        model Fog::Compute::Libvirt::Server

        def all(filter=nil)
          data=[]
          filter={} if filter.nil?
          include_defined=filter.has_key?(:defined) ? filter[:defined] : true  
          include_active=filter.has_key?(:active) ? filter[:active] : true  

          unless filter.has_key?(:name) || filter.has_key?(:uuid)
            if include_defined
              connection.raw.list_defined_domains.map do |domain|
                data << { :raw => connection.raw.lookup_domain_by_name(domain) }
              end
            end
            if include_active
              connection.raw.list_domains.each do |domain|
                data << { :raw => connection.raw.lookup_domain_by_id(domain) }
              end
            end
          else
            domain=nil
            begin
              domain=self.get_by_name(filter[:name]) if filter.has_key?(:name)
              domain=self.get_by_uuid(filter[:uuid]) if filter.has_key?(:uuid)

            rescue ::Libvirt::RetrieveError
              return nil
            end
            unless domain.nil?
              data << { :raw => domain }
            end
          end

          load(data)
        end

        def get(uuid)
          vm = all(:uuid => uuid)
          vm.first if vm
        end

        def bootstrap(new_attributes = {})
          raise 'Not Implemented'
          # server = create(new_attributes)
          # server.start
          # server.wait_for { ready? }
          # server.setup(:password => server.password)
          # server
        end

        # private #making these internals private screws up reload

        # Retrieve the server by uuid
        def get_by_uuid(uuid)
          server=connection.raw.lookup_domain_by_uuid(uuid)
          return server
          #          new(:raw => machine)
        end

        # Retrieve the server by name
        def get_by_name(name)
          server=connection.raw.lookup_domain_by_name(name)
          return server
          #          new(:raw => machine)
        end

      end #class
    end #Class
  end #module
end #Module
