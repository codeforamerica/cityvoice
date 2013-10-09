class StatusController < ApplicationController
  def check
    render :inline => "".to_json
  end
end
