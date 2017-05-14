require 'rubygems'  
require 'serialport' 
require 'pubnub'

def getmodems
  io = IO.popen '/bin/ls /dev', 'r'
  $stdout = io  
  $stdout = IO.new 0
  r = io.read.split("\n").select {|l| l =~ /cu.usbmodem/}
  io.close
  r
end

def _write(mode)
  getmodems.each do |m|
    begin
      port_str = "/dev/#{m}"
      baud_rate = 9600  
      data_bits = 8  
      stop_bits = 1  
      parity = SerialPort::NONE  

      sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)  

      0.upto(3) do |i|
        sp.puts(mode)
        sleep(1)
      end      
    rescue
    end
  end
end

def open_lock
  _write(1)
end

def close_lock
  _write(2)
end

is_locked = nil

pubnub = Pubnub.new(
    subscribe_key: 'sub-c-17053e2c-383f-11e7-a268-0619f8945a4f',
    publish_key: 'pub-c-0eb1415c-3ea2-4b4f-857f-d53cad2a47d9'
)

callback = Pubnub::SubscribeCallback.new(
    message:  ->(envelope) { 
        next_locked = envelope.result[:data][:message]["locked"]

	if is_locked.nil?
          is_locked = next_locked
        else
          if is_locked != next_locked
            is_locked = next_locked
            if is_locked
              open_lock
            else
              close_lock
            end
          end
        end
    }
)

pubnub.add_listener(callback: callback)
 
pubnub.subscribe(channels: [:bike_parking_club_lock_state])

loop do
  pubnub.publish(channel: :bike_parking_club_lock_state, message: {currentState: {}})
  sleep 0.3
end
