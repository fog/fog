require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))
require 'digest/md5'

module Fog
  module Voxel

    extend Fog::Provider

    service(:compute, 'voxel/compute')

    def self.create_signature(secret, options)
      to_sign = options.keys.map { |k| k.to_s }.sort.map { |k| "#{k}#{options[k.to_sym]}" }.join("")
      Digest::MD7.hexdigest( secret + to_sign )
    end
  end
end
