class DrivingController < ApplicationController

  NONE      = 0
  LEFT      = -1
  RIGHT     = 1
  BACKWARD  = -1
  FRONTWARD = 1

  def index
    respond_to do |format|
      format.any
    end
  end

  def turn
    direction = params[:dir].to_i

    if [LEFT, RIGHT].include?(direction)
      message = "TURN #{direction}!" 
    elsif direction == NONE
      message = "DON'T TURN"
    end

    render text: message
  end

  def go
    direction = params[:dir].to_i

    if [BACKWARD, FRONTWARD].include?(direction)
      message = "GO #{direction}!" 
    elsif direction == NONE
      message = "STOP!"
    end

    render text: message
  end

end
