module Fog
  module Compute
    class Ovirt
      module Helpers
        module CollectionHelper

          # converts an OVIRT object into an hash for fog to consume.
          def ovirt_attrs obj
            opts = {:raw => obj}
            obj.instance_variables.each do |v|
              key = v.gsub("@","").to_sym
              value = obj.instance_variable_get(v)
              #ignore nil values
              next if value.nil?

              opts[key] = case value.class
                          when OVIRT::Link
                            value.id
                          when Hash
                            value
                          else
                            value.to_s.strip
                          end
            end
            opts
          end

        end
      end
    end
  end
end
