#!/bin/sh

/usr/sbin/nsd -d &
NSD_PID=$!

sleep 3

/usr/sbin/unbound -d &
UNBOUND_PID=$!

term_handler() {
	kill -TERM "$UNBOUND_PID" 2>/dev/null
	kill -TERM "$NSD_PID" 2>/dev/null
	wait "$UNBOUND_PID" 2>/dev/null
	wait "$NSD_PID" 2>/dev/null
	exit 0
}

trap 'term_handler' INT TERM

while kill -0 "$UNBOUND_PID" 2>/dev/null && kill -0 "$NSD_PID" 2>/dev/null; do
	sleep 1
done
term_handler
