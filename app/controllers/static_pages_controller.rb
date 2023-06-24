require 'openai_chat'

class StaticPagesController < ApplicationController
  include ApplicationHelper

  respond_to :html

  def home
  end
end
