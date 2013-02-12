
class TerremarkParser < Fog::Parsers::Base

  def extract_attributes(attributes_xml)
    attributes = {}
    until attributes_xml.empty?
      if attributes_xml.first.is_a?(Array)
        until attributes_xml.first.empty?
          attribute = attributes_xml.first.shift
          attributes[attribute.localname] = attribute.value
        end
      else
        attribute = attributes_xml.shift
        attributes[attribute.localname] = attribute.value
      end
    end
    attributes
  end
end

