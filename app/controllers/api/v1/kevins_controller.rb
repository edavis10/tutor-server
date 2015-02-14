module Api::V1
  class KevinsController < ApiController

    def index
      json = {field1: 0, field2: [1,2,3]}
      render json: KevinFixedJsonRepresenter.new(Hashie::Mash.new(json)).to_json, status: :ok
    end

    def convert
      stig = Hashie::Mash.new(field1: nil, field2: nil)
      consume!(stig, represent_with: KevinFixedJsonRepresenter)

      if stig.field1 % 4 == 0
        render json: { error: 'multiple of 4' }, status: 400
      else
        stig.field1 = stig.field1 + 1
        respond_with stig, represent_with: KevinFixedJsonRepresenter
      end
    end

  end
end
