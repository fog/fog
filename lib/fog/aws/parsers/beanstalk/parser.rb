module Fog
  module Parsers
    module AWS
      module ElasticBeanstalk

        class BaseParser < Fog::Parsers::Base

          def initialize(result_name)
            super()
            @result_name = result_name
            @tags = {}
          end


          def tag name, *traits
            if traits.length == 1
              @tags[name] = traits.last
            end


          end

          def start_element(name, attrs = [])
            super
            puts "Processing tag #{name}"
            if name == 'member'
              if @parse_stack.last[:type] == :object
                @parse_stack.last[:value] << {}
              end
            else
              case @tags[name]

                when :object_list #, :string_list
                  pp @parse_stack.last[:value]
                  value = @parse_stack.last[:value]
                  pp value
                  # Use
                  if value.kind_of?(Array)
                    value.last[name] = []
                    value = value.last[name]
                  else
                    value[name] = []
                    value = value[name]
                  end

                  pp value
                  #value = []

                  @parse_stack.push({ :type => :object, :value => value })
                #pp @parse_stack.last[:value]
                #@parse_stack.last[:value].last[name] = []
                #@parse_stack.push({ :type => :value, :value => @parse_stack.last[:value].last[name] })
                when :string_list
                  @parse_stack.last[:value].last[name] = []

                  @parse_stack.push({ :type => :value, :value => @parse_stack.last[:value].last[name] })

              end
            end
          end


          def end_element(name)
            case name
              when 'member'
                if @parse_stack.last[:type] == :value
                  @parse_stack.last[:value] << value
                end
              when 'RequestId'
                @response['ResponseMetadata'][name] = value
              else
                case @tags[name]
                  when :object_list, :string_list
                    @parse_stack.pop()
                  when :string
                    @parse_stack.last[:value].last[name] = value
                  when :datetime
                    @parse_stack.last[:value].last[name] = Time.parse value
                end
            end
          end

        end
      end
    end
  end
end

