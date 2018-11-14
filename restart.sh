#!/bin/sh
export PATH=/bin:/usr/bin

cd /Users/collector/Desktop/experiments
LOG=manager.log

if [ -f manager.pid ]
then
	PID1=$(cat manager.pid)
	echo found manager.pid $PID1
fi

PID2=$(pgrep python)
echo pid from pgrep is $PID2

if [ "x$PID1" != "x" ]
then
	echo killing $PID1
	kill $PID1
fi
if [ "x$PID2" != "x" ] && [ "$PID2" != "$PID1" ]
then
	echo killing $PID2
	kill $PID2
fi
echo restarting on $(date) >> $LOG
./manager.py >> $LOG 2>&1 &
NEWPID=$!
echo $NEWPID > manager.pid
echo new pid $NEWPID >> $LOG
cat manager.pid
