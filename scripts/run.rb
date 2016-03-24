require 'orocos'
include Orocos

#if !ARGV[0]
#    STDERR.puts "usage: run.rb <device name> <baud rate>"
#    exit 1
#end

Orocos.initialize

Orocos::Process.run 'flasher::Task' => "flasher", :valgrind => false do
    driver = TaskContext.get 'flasher'
    #Orocos.log_all_ports

    driver.io_port = "serial:///dev/ttyS7:57600"
    #driver.io_port = "file:///tmp/serial.txt"
        

    driver.configure
    driver.start

    writer_command = driver.command.writer;

    loop do
        
      sample = writer_command.new_sample
      sample.light1 = 0;
      sample.light2 = 0;
      sample.light3 = 0;
      
        writer_command.write(sample)

        puts 'lights off'
        
        sleep 1.0

        sample = writer_command.new_sample
      sample.light1 = 0;
      sample.light2 = 0;
      sample.light3 = 1;
      
        writer_command.write(sample)

        puts 'lights on'
        
        sleep 1.0
        
    end
end

