module Fog
  module Parsers
    module Vcloud

      class Network < Fog::Parsers::Vcloud::Base

        def reset
          @response = Struct::VcloudNetwork.new([])
        end

        def start_element(name,attributes=[])
          super
          case name
          when "Network"
            handle_root(attributes)
          when "Features"
            @in = :features
          when "Configuration"
            @in = :configuration
            @response.configuration = Struct::VcloudNetworkConfiguration.new
          end
        end

        def end_element(name)
          case @in
          when :features
            case name
            when "FenceMode"
              @response.features << Struct::VcloudNetworkFenceMode.new(@value)
            when "Features"
              @in = nil
            end
          when :configuration
            case name
            when "Gateway","Netmask","Dns"
              @response.configuration[name.downcase] = @value
            when "Configuration"
              @in = nil
            end
          else
            case name
            when "Description"
              @response.description = @value
            end
          end
        end

      end

    end
  end
end

