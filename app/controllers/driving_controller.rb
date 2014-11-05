class DrivingController < ApplicationController

  NONE      = 0
  LEFT      = -1
  RIGHT     = 1
  BACKWARD  = -1
  FRONTWARD = 1

  GPIO_GO         = 17
  GPIO_GO_BACK    = 18
  GPIO_TURN_LEFT  = 21
  GPIO_TURN_RIGHT = 22

  DRIVE_CONTORL = {
    go: {
      FRONTWARD => { gpio: GPIO_GO,         message: "GO" },
      BACKWARD  => { gpio: GPIO_GO_BACK,    message: "GO BACK" },
    },
    turn: {
      LEFT  => { gpio: GPIO_TURN_LEFT,  message: "TURN LEFT" },
      RIGHT => { gpio: GPIO_TURN_RIGHT, message: "TURN RIGHT" }
    }
  }

  def index
    respond_to do |format|
      format.any
    end
  end

  def turn
    direction = params[:dir].to_i

    if [LEFT, RIGHT].include?(direction)
      GPIO.write(DRIVE_CONTORL[:turn][direction][:gpio], 1)
      message = DRIVE_CONTORL[:turn][direction][:message]
    elsif direction == NONE
      GPIO.write(DRIVE_CONTORL[:go][LEFT][:gpio], 0)
      GPIO.write(DRIVE_CONTORL[:go][RIGHT][:gpio], 0)
      message = "DON'T TURN"
    end

    render text: message
  end

  def go
    direction = params[:dir].to_i

    if [BACKWARD, FRONTWARD].include?(direction)
      GPIO.write(DRIVE_CONTORL[:go][BACKWARD][:gpio], 1)
      system "gpio write 0 1"
      logger.info("GPIO.write(#{DRIVE_CONTORL[:turn][direction][:gpio]}, 1)")
      message = DRIVE_CONTORL[:go][direction][:message]
    elsif direction == NONE
      GPIO.write(DRIVE_CONTORL[:go][BACKWARD][:gpio], 0)
      GPIO.write(DRIVE_CONTORL[:go][FRONTWARD][:gpio], 0)
      system "gpio write 0 0"
      message = "STOP"
    end

    render text: message
  end

end
