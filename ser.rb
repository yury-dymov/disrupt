require 'rubygems'  
require 'serialport' 

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

def open
  _write(1)
end

def close
  _write(2)
end

close
