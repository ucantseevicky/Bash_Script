#!/bin/bash
Code:
SNMPCOMMUNITY=public
IP=***
INTNUMBER=1
OUT=$(snmpget -v2c -c $SNMPCOMMUNITY $IP ifOutOctets.$INTNUMBER | awk '{print $4}')
IN=$(snmpget -v2c -c $SNMPCOMMUNITY $IP ifInOctets.$INTNUMBER | awk '{print $4}')
SPEED=$(snmpget -v2c -c $SNMPCOMMUNITY $IP ifSpeed.$INTNUMBER | awk '{print $4}')
TIME=10
        if [ -z "$OUT" ] || [ -z "$IN" ]; then
                msg="Unable to retrieve SNMP info."
                state=CRITICAL
                echo $state $msg
                exit 2
        else
                sleep $TIME
                OUT2=$(snmpget -v2c -c $SNMPCOMMUNITY $IP ifOutOctets.$INTNUMBER | awk '{print $4}')
                IN2=$(snmpget -v2c -c $SNMPCOMMUNITY $IP ifInOctets.$INTNUMBER | awk '{print $4}')
                DELTAOUT=$(echo "$OUT2-$OUT" | bc)
                DELTAIN=$(echo "$IN2-$IN" | bc)
                INPUTBW=$(echo "$DELTAIN*8*100/$TIME*$SPEED" | bc)
                OUTPUTBW=$(echo "$DELTAOUT*8*100/$TIME*$SPEED" | bc)
                echo Inbound: $INPUTBW"bps"
                echo Outbound: $OUTPUTBW"bps"

        fi
