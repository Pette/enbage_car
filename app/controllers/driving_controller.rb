class DrivingController < ApplicationController

  NONE      = 0
  LEFT      = -1
  RIGHT     = 1
  BACKWARD  = -1
  FRONTWARD = 1


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
    start_of_action_time      = (Time.now.to_f * 1000).to_i
    logger.info "[OK][DrivingController][turn] time from js call         = #{start_of_action_time - params[:time].to_i}ms"

    if [LEFT, RIGHT].include?(direction)
      # GPIO.write(DRIVE_CONTORL[:turn][direction][:gpio], 1)
      system "gpio write #{DRIVE_CONTORL[:turn][direction][:gpio]} 1"
      message = DRIVE_CONTORL[:turn][direction][:message]
    elsif direction == NONE
      # GPIO.write(DRIVE_CONTORL[:turn][LEFT][:gpio], 0)
      # GPIO.write(DRIVE_CONTORL[:turn][RIGHT][:gpio], 0)
      system "gpio write #{DRIVE_CONTORL[:turn][LEFT][:gpio]} 0"
      system "gpio write #{DRIVE_CONTORL[:turn][RIGHT][:gpio]} 0"
      message = "DON'T TURN"
    end

    end_of_action_time      = (Time.now.to_f * 1000).to_i
    logger.info "[OK][DrivingController][turn] time from begin of action = #{start_of_action_time - start_of_action_time}ms"

    render json: { message: message, time: end_of_action_time }
  end

  def go
    direction = params[:dir].to_i
    start_of_action_time      = (Time.now.to_f * 1000).to_i
    logger.info "[OK][DrivingController][go] time from js call         = #{start_of_action_time - params[:time].to_i}ms"

    if [BACKWARD, FRONTWARD].include?(direction)
      # GPIO.write(DRIVE_CONTORL[:go][BACKWARD][:gpio], 1)
      system "gpio write #{DRIVE_CONTORL[:go][direction][:gpio]} 1"
      message = DRIVE_CONTORL[:go][direction][:message]
    elsif direction == NONE
      # GPIO.write(DRIVE_CONTORL[:go][BACKWARD][:gpio], 0)
      # GPIO.write(DRIVE_CONTORL[:go][FRONTWARD][:gpio], 0)
      system "gpio write #{DRIVE_CONTORL[:go][BACKWARD][:gpio]} 0"
      system "gpio write #{DRIVE_CONTORL[:go][FRONTWARD][:gpio]} 0"
      message = "STOP"
    end

    end_of_action_time      = (Time.now.to_f * 1000).to_i
    logger.info "[OK][DrivingController][go] time from begin of action = #{start_of_action_time - start_of_action_time}ms"

    render json: { message: message, time: end_of_action_time }
  end

end
