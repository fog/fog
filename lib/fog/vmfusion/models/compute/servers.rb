require 'fog/core/collection'
require 'fog/vmfusion/models/compute/server'

module Fog
  module Compute
    class Vmfusion

      class Servers < Fog::Collection

        model Fog::Compute::Vmfusion::Server

        def all(filter=nil)

          data=[]

          filter={} if filter.nil?
          unless filter.has_key?(:name)
            vm_names=::Fission::VM.all
            vm_names.each do |vm_name|
              data << { :raw => ::Fission::VM.new(vm_name)}
            end
          else
              data << { :raw => ::Fission::VM.new(filter[:name])}
           end

          load(data)

        end

        def get(name)
          self.all(:name =>name).first
        end

      end
    end
  end
 end
