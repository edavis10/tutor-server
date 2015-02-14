class Api::V1::KevinsController < Api::V1::ApiController

  def index
    json = {field1: 0, field2: [1,2,3]}
    render json: Api::V1::KevinFixedJsonRepresenter.new(Hashie::Mash.new(json)).to_json, status: :ok
  end

  def convert
    stig = Hashie::Mash.new(field1: nil, field2: nil)
    consume!(stig, represent_with: Api::V1::KevinFixedJsonRepresenter)
    stig.field1 = stig.field1 + 1
    render json: Api::V1::KevinFixedJsonRepresenter.new(stig).to_json, status: :ok
  end

end
