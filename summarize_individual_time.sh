#! /bin/bash
# show the runtime of each gaggle of size n on all N nodes.
# that means for n=1 the timing is for the start of 1
# python interpreter. for n=2 for the time it takes 2 concurrent
# python interpreters to start, and so on.

tmp=$(mktemp ./XXXX)
for f in log/*; do
    a=( $(basename "$f" | tr '.' ' ') )
    interpreter=${a[0]}
    n=${a[1]}
    N=${a[2]}
    while read line; do
        echo "${interpreter}|${n}|${N}|$((n*N))|${line##*|}" >> $tmp
    done < $f
done
sort -t'|' -k1,1 -k4,4n -k2,2n -k3,3n $tmp
rm $tmp
