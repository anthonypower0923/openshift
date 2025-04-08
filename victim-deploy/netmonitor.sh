#!/bin/bash

# Bash script to calculate throughput and packets/sec
# Based on code from https://discuss.aerospike.com/t/benchmarking-throughput-and-packet-count-with-iperf3/2791

if [ -z "$1" ]; then
        echo
        echo usage: $0 [network-interface]
        echo
        echo defaulting to eth0
        interface="eth0"
else
        interface="$1"
fi

TXPFILE="/sys/class/net/$interface/statistics/tx_packets"
TXBFILE="/sys/class/net/$interface/statistics/tx_bytes"
RXPFILE="/sys/class/net/$interface/statistics/rx_packets"
RXBFILE="/sys/class/net/$interface/statistics/rx_bytes"
INTERVAL=2 # Approximate time in seconds between readings

while true
do
        T1=$(date +%s%6N) # time in microseconds
        STATS1=$(cat $TXBFILE $RXBFILE $TXPFILE $RXPFILE)

        sleep $INTERVAL

        T2=$(date +%s%6N) # time in microseconds
        STATS2=$(cat $TXBFILE $RXBFILE $TXPFILE $RXPFILE)

        TB1=$(echo $STATS1 | cut -d ' ' -f 1)
        RB1=$(echo $STATS1 | cut -d ' ' -f 2)
        TP1=$(echo $STATS1 | cut -d ' ' -f 3)
        RP1=$(echo $STATS1 | cut -d ' ' -f 4)

        TB2=$(echo $STATS2 | cut -d ' ' -f 1)
        RB2=$(echo $STATS2 | cut -d ' ' -f 2)
        TP2=$(echo $STATS2 | cut -d ' ' -f 3)
        RP2=$(echo $STATS2 | cut -d ' ' -f 4)

        T=$(( T2-T1 ))
        
        TXB=$(( TB2-TB1 ))
        RXB=$(( RB2-RB1 ))
        TOB=$(( TXB+RXB ))
        TXBPS=$(( TXB * 10**6 / T ))
        RXBPS=$(( RXB * 10**6 / T ))
        TOBPS=$(( TOB * 10**6 / T ))

        TXP=$(( TP2-TP1 ))
        RXP=$(( RP2-RP1 ))
        TOP=$(( TXP+RXP ))
        TXPPS=$(( (TXP * 10**6 + T/2) / T )) #round up
        RXPPS=$(( (RXP * 10**6 + T/2) / T )) #round up
        TOPPS=$(( (TOP * 10**6 + T/2) / T )) #round up

        # Display "<1 pkts/s" if packets were transfered, but it is a fractional amount per second 
        if (( TXPPS == 0 && TXP > 0 )); then
                FORMATTED_TXPPS="<1"
        else
                FORMATTED_TXPPS=$(printf "%'10d" $TXPPS)
        fi

        if (( RXPPS == 0 && RXP > 0 )); then
                FORMATTED_RXPPS="<1"
        else
                FORMATTED_RXPPS=$(printf "%'10d" $RXPPS)
        fi

        if (( TOPPS == 0 && TOP > 0 )); then
                FORMATTED_TOPPS="<1"
        else
                FORMATTED_TOPPS=$(printf "%'10d" $TOPPS)
        fi

        if (( TOBPS * 8 / 10**6 == 0 )); then
                BPS_OUTPUT=$(printf "  TX: %'10d Kbit/s   RX: %'10d Kbit/s   TOTAL: %'10d Kbit/s" $(( TXBPS * 8 / 10**3 )) $(( RXBPS * 8 / 10**3 )) $(( TOBPS * 8 / 10**3 )))
        else
                BPS_OUTPUT=$(printf "  TX: %'10d Mbit/s   RX: %'10d Mbit/s   TOTAL: %'10d Mbit/s" $(( TXBPS * 8 / 10**6 )) $(( RXBPS * 8 / 10**6 )) $(( TOBPS * 8 / 10**6 )))
        fi
        PPS_OUTPUT=$(printf "  TX: %10s pkts/s   RX: %10s pkts/s   TOTAL: %10s pkts/s" $FORMATTED_TXPPS $FORMATTED_RXPPS $FORMATTED_TOPPS)
        AVG_OUTPUT=$(printf "  TX: %'10d bytes    RX: %'10d bytes    [Avg packet size]" $(( TXP == 0 ? 0 : (TXB + TXP/2) / TXP)) $(( RXP == 0 ? 0 : (RXB + RXP/2) / RXP )))

        printf "\n${BPS_OUTPUT}\n${PPS_OUTPUT}\n${AVG_OUTPUT}\n"
done