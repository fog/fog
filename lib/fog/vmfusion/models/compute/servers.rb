require 'fog/core/collection'
require 'fog/vmfusion/models/compute/server'

module Fog
  module Compute
    class Vmfusion

      class Servers < Fog::Collection

        model Fog::Compute::Vmfusion::Server

        def all(filter = nil)

          data = []

          states = ::Fission::VM.all_with_status.data

          filter = {} if filter.nil?
          unless filter.has_key?(:name)
            vms=::Fission::VM.all.data
            vms.each do |vm|
              data << { :raw =>  { :fission => vm,
                                   :state   => states[vm.name] } }
            end
          else
            data << { :raw => { :fission => ::Fission::VM.new(filter[:name]),
                                :state   => states[filter[:name]] } }
          end

          load(data)

        end

        def get(name)
          self.all(:name => name).first
        end

      end
    end
  end
end
