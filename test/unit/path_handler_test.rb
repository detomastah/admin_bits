require 'test_helper'
require 'admin_bits/admin_resource/path_handler'

class PathHandlerTest < ActiveSupport::TestCase
  test "path handler accepts procs with param-based route" do
    routes = mock('Routes')
    routes.expects(:admin_mega_path).with('some_id')

    proc = Proc.new { |params| admin_mega_path(params[:obj_id]) }

    handler = AdminBits::AdminResource::PathHandler.new(proc, {obj_id: 'some_id'})
    handler.stubs(:routes).returns(routes)

    handler.path
  end
end

