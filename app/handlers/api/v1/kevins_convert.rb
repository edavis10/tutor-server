module Api::V1
  class KevinsConvert
    lev_handler

    protected
    
    def authorized?
      true
    end

    def handle
      stig = Hashie::Mash.new(field1: nil, field2: nil)
      KevinFixedJsonRepresenter.new(stig).from_json(request.body.read)

      fatal_error code: :multiple_of_4 if stig.field1 % 4 == 0

      stig.field1 = stig.field1 + 1
      outputs.stig = stig
    end
  end
end
