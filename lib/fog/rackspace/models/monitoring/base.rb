require 'digest/md5'

module Fog
  module Rackspace
    class Monitoring
      class Base < Fog::Model
        attribute :created_at
        attribute :updated_at

        # Back to drawing board on this one I think
        def hash
          attrs = attributes.dup
          attrs.delete_if {|key, value| [:created_at, :updated_at, :id].include?(key)}
          attrs.delete_if {|key, value| value.kind_of?(Base) }
          keys = attrs.keys.map{|sym| sym.to_s}.sort.join ''
          values = attrs.values.map{|sym| sym.to_s}.sort.join ''
          Digest::MD5.hexdigest(keys + values)
        end

        def compare?(b)
          a_o = params
          b_o = b.params
          remain = a_o.reject {|key, value| b_o[key] === value}
          remain.empty?
        end
      end
    end
  end
end
