module Api::V1
  class TaskStepRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }

    property :type,
             type: String,
             writeable: false,
             readable: true,
             getter: lambda { |*| tasked_type.downcase },
             schema_info: {
               required: true,
               description: "The type of this TaskStep, one of: #{Api::V1::TaskedRepresenterMapper.models.collect{|klass| "'" + klass.name.downcase + "'"}.join(',')}"
             }

    property :title,
             type: String,
             writeable: false,
             readable: true,
             schema_info: {
               required: true,
               description: "The title of this TaskStep"
             }

    property :url,
             type: String,
             writeable: false,
             readable: true,
             as: :content_url,
             schema_info: {
               required: false,
               description: "The URL for the associated Resource"
             }

    property :content,
             type: String,
             writeable: false,
             readable: true,
             as: :content_html,
             schema_info: {
               required: false,
               description: "The Resource content as HTML"
             }

  end
end