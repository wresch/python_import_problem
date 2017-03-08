#! /bin/bash
# takes minimum of start and max of end to calculate overall
# time it took to start and end all python interpreters

tmp=$(mktemp ./XXXX)
for f in log/*; do
    a=( $(basename "$f" | tr '.' ' ') )
    interpreter=${a[0]}
    n=${a[1]}
    N=${a[2]}
    s=$(awk -F'|' 'NR==1{s=$2}; $2 < s {s=$2}; END {print s}' $f)
    e=$(awk -F'|' 'NR==1{e=$3}; $3 > e {e=$3}; END {print e}' $f)
    elapsed=$( echo "$e - $s" | bc -l)
    echo "${interpreter}|${n}|${N}|$((n*N))|${elapsed}" >> $tmp
done
sort -t'|' -k1,1 -k4,4n -k2,2n -k3,3n $tmp
rm $tmp
