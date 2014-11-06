GPIO_GO         = 0
GPIO_GO_BACK    = 1
GPIO_TURN_LEFT  = 2
GPIO_TURN_RIGHT = 3

system "gpio mode #{GPIO_GO} out"
system "gpio mode #{GPIO_GO_BACK} out"
system "gpio mode #{GPIO_TURN_LEFT} out"
system "gpio mode #{GPIO_TURN_RIGHT} out"


# GPIO = WiringPi::GPIO.new
