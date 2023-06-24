class TestLogsController < ApplicationController
  include ApplicationHelper

  def index
    if params.has_key?(:user_id)
      @user = User.find_by_user_id(params[:user_id])
      @logs = TestLog.where(:user_id => params[:user_id]).order('id DESC')
    else
      @user = nil
      @logs = TestLog.order('id DESC')
    end
  end

  def destroy
    @log = TestLog.find(params[:id])
    @log.destroy
    
    redirect_to test_logs_path, :notice => 'Test Log successfully deleted'  
  end
end
