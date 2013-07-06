require 'fog/core/model'

module Fog
  module AWS
    class RDS

      class LogFile < Fog::Model

        attribute :name, :aliases => %w(LogFileName)
        attribute :size, :aliases => 'Size', :type => :integer
        attribute :last_written, :aliases => 'LastWritten', :type => :time

      end
    end
  end
end
