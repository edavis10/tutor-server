module Api::V1
  class KevinFixedJsonRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :field1,
             type: Integer,
             readable: true,
             writeable: true,
             schema_info: {
               description: "field1"
             }

    collection :field2,
               readable: true,
               writeable: true,
               schema_info: {
                 description: "field2"
               }
  end
end