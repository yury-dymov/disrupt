require 'rubygems'  
require 'serialport' 


#params for serial port  
port_str = "/dev/cu.usbmodem41"  #may be different for you  
baud_rate = 9600  
data_bits = 8  
stop_bits = 1  
parity = SerialPort::NONE  

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)  

0.upto(3) do |i|
  sp.puts(2)
  sleep(1)
end


