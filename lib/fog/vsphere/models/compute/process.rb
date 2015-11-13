require 'fog/compute/models/server'

module Fog
  module Compute
    class Vsphere
      class Process < Fog::Model
        attribute :cmd_line
        attribute :end_time
        attribute :exit_code
        attribute :name
        attribute :owner
        attribute :pid
        attribute :start_time
      end
    end
  end
end

