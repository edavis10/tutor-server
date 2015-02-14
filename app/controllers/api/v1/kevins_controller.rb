class Api::V1::KevinsController < Api::V1::ApiController

  def index
    render json: {field1: 0, field2: [1,2,3]}, status: :ok
  end

end
