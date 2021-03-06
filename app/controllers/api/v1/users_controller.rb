class Api::V1::UsersController < Api::V1::ApiController

  resource_description do
    api_versions "v1"
    short_description 'Represents a user in the system'
    description <<-EOS
      User description to be written...
    EOS
  end

  api :GET, '/user', <<-EOS
    If requested by a session/OAuth user, returns header ok (200).
    Otherwise returns header forbidden (403).
  EOS
  def show
    ## TODO: Eventually convert this to something like:
    ##         standard_real(current_human_user)
    ##       once error/exception handling mechasmism
    ##       have been updated.
    status = if current_human_user.nil?
               :forbidden
             elsif current_human_user.is_anonymous?
               :forbidden
             else
               :ok
             end
    head status
  end

  api :GET, '/user/tasks', 'Gets all tasks assigned to the User making the request'
  description <<-EOS 
    #{json_schema(Api::V1::TaskSearchRepresenter, include: :readable)}
  EOS
  def tasks
    OSU::AccessPolicy.require_action_allowed!(:read_tasks, current_api_user, current_human_user)
    outputs = SearchTasks.call(q: "user_id:#{current_human_user.id}").outputs
    respond_with outputs, represent_with: Api::V1::TaskSearchRepresenter
  end

end
