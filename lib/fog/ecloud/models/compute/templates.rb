require 'fog/ecloud/models/compute/template'

module Fog
  module Compute
    class Ecloud
      class Templates < Fog::Ecloud::Collection
        identity :href

        model Fog::Compute::Ecloud::Template

        def all
          r_data = []
          data = service.get_templates(href).body[:Families]
          data[:Family].is_a?(Hash) ? data = [data[:Family]] : data = data[:Family]
          data.each do |d|
            cats = d[:Categories][:Category]
            cats = [cats] if cats.is_a?(Hash)
            cats.each do |cat|
              cat[:OperatingSystems][:OperatingSystem].is_a?(Hash) ? cat = [cat[:OperatingSystems][:OperatingSystem]] : cat = cat[:OperatingSystems][:OperatingSystem]
              cat.each do |os|
                os[:Templates][:Template].is_a?(Hash) ? os = [os[:Templates][:Template]] : os = os[:Templates][:Template]
                os.each do |template|
                  r_data << template
                end
              end
            end
          end
          load(r_data)
        end

        def get(uri)
          if data = service.get_template(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
