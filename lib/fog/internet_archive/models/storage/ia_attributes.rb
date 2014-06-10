module Fog
  module Storage
    module IAAttributes
		  # you can add other x-archive-metadata-* values, but these are standard
		  IA_STANDARD_METADATA_FIELDS = %q[hidden, title, collection, creator, mediatype, description, date, subject, licenseurl, pick, noindex, notes, rights, contributor, language, coverage, credits]

		  # for x-archive-metadata-mediatype, these are the valid values
		  IA_VALID_MEDIA_TYPES = %q[audio, data, etree, image, movies, software, texts, web]

			module ClassMethods
			  def ia_metadata_attribute(name)
			    attribute(name, :aliases=>['amz','archive'].map{|p|"x-#{p}-#{name.to_s.tr('_','-')}"})
			  end
			end

			module InstanceMethods
				# set_metadata_array_headers(:collections, options)
				def set_metadata_array_headers(array_attribute, options={})
				  attr_values = Array(self.send(array_attribute))
				  opt_values = options.map do |key,value|
				    options.delete(key) if (key.to_s =~ /^x-(amz||archive)-meta(\d*)-#{array_attribute.to_s[0..-2]}/)
				  end
				  values = (attr_values + opt_values).compact.sort.uniq
				  # got the values, now add them back to the options
				  if values.size == 1
				    options["x-archive-meta-#{array_attribute.to_s[0..-2]}"] = values.first
				  elsif values.size > 1
				    values[0,99].each_with_index do |value, i|
				      options["x-archive-meta#{format("%02d", i+1)}-#{array_attribute.to_s[0..-2]}"] = value
				    end
				  end
				end
			end
		end
	end
end
