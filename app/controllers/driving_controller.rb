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
    io = WiringPi::GPIO.new(WPI_MODE_SYS)
    logger.info io

    if [BACKWARD, FRONTWARD].include?(direction)
      # system "echo '1' > /sys/class/gpio/gpio17/value"
      message = "GO #{direction}"
      io.write(17, direction.abs)
    elsif direction == NONE
      # system "echo '0' > /sys/class/gpio/gpio17/value"
      io.write(17, 0)
      message = "STOP"
    end

    render text: message
  end

end
