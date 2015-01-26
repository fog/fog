require 'fog/ninefold'
require 'fog/atmos'

module Fog
  module Storage
    class Ninefold < Fog::Storage::Atmos
      STORAGE_HOST = "onlinestorage.ninefold.com" #"api.ninefold.com"
      STORAGE_PATH = "" #"/storage/v1.0"
      STORAGE_PORT = "80" # "443"
      STORAGE_SCHEME = "http" # "https"

      requires :ninefold_storage_token, :ninefold_storage_secret
      recognizes :persistent

      model_path 'fog/storage/atmos/models'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      module Utils
      end

      class Mock < Fog::Storage::Atmos::Mock
        include Utils

        def initialize(options={})
          @ninefold_storage_token = options[:ninefold_storage_token]
          @ninefold_storage_secret = options[:ninefold_storage_secret]
        end

        def request(options)
          raise "Ninefold Storage mocks not implemented"
        end
      end

      class Real < Fog::Storage::Atmos::Real
        include Utils

        def initialize(options={})
          endpoint = "#{STORAGE_SCHEME}://"\
                     "#{STORAGE_HOST}:"\
                     "#{STORAGE_PORT}"\
                     "#{STORAGE_PATH}"
          options[:atmos_storage_endpoint] = endpoint
          options[:atmos_storage_token] = options[:ninefold_storage_token]
          options[:atmos_storage_secret] = options[:ninefold_storage_secret]
          super(options)
        end
      end
    end
  end
end
