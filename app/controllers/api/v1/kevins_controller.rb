module Api::V1
  class KevinsController < ApiController

    include Lev::HandleWith

    ## This is needed because Lev 'accidentally' calles current_user as
    ## a default parameter value, even though it isn't used by this
    ## feature.
    def current_user
    end

    def index
      json = {field1: 0, field2: [1,2,3]}
      render json: KevinFixedJsonRepresenter.new(Hashie::Mash.new(json)).to_json, status: :ok
    end

    def convert
      ## spooky action at a distance; see:
      ##   https://github.com/lml/lev/blob/master/lib/lev/handle_with.rb#L33
      ## for definition of @handler_result
      handle_with(KevinsConvert,
        success: lambda { success_callback(@handler_result) },
        failure: lambda { failure_callback(@handler_result) })
    end

    private

    def success_callback(handler_result)
      respond_with handler_result.outputs.stig, represent_with: KevinFixedJsonRepresenter
    end

    def failure_callback(handler_result)
      case handler_result.errors.first.code
      when :multiple_of_4
        render json: { error: 'multiple of 4' }, status: 400
      else
        render json: { error: 'unknown error' }, status: 500
      end
    end

  end
end
