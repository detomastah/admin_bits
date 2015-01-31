class Admin::BaseController < ApplicationController
  include AdminBits::Controller

  layout 'admin_bits/layout'
end
