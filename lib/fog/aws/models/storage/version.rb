require 'fog/core/model'

module Fog
  module Storage
    class AWS

      class Version < Fog::Model

        identity  :version,             :aliases => 'VersionId'

        attribute :key,                 :aliases => 'Key'
        attribute :last_modified,       :aliases => ['Last-Modified', 'LastModified']
        attribute :latest,              :aliases => 'IsLatest', :type => :boolean
        attribute :content_length,      :aliases => ['Content-Length', 'Size'], :type => :integer
        attribute :delete_marker,       :type => :boolean

        def file
          @file ||= collection.file.directory.files.get(key, 'versionId' => version)
        end
      end

    end
  end
end
