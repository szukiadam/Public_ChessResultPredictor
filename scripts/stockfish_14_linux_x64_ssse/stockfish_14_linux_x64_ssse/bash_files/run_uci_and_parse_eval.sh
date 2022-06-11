#!/bin/bash

destdir=uci_output.txt

> $destdir

result=$(expect stockfish_script.exp)
echo "$result" >> "$destdir"

# contrib_terms=$(cat $destdir | grep -i "|" | head -16 | tr \| ' ' | tr 'King safety' 'KingSafety' | awk -F' ' '{ print $1 $2 $3 $4 $5 $6 $7$8 $9 }' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | tr \\n ',' | sed 's/.$//')


bucket_values=$(cat $destdir | grep -i "|" | tail -8 | tr '  ' ' ' | tr \| ' ' | awk -F' ' '{ print $2 $3 $4 $5 $6 $7 $8 $9 }' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | tr \\n ',' | sed 's/.$//')

get_used_bucket=$(cat $destdir | grep -i "|" | tail -8 | grep -F '<--' | tr \| ' ' | awk -F ' ' '{print $1}')

classical_eval=$(cat $destdir | grep -F 'Classical evaluation' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
nnue_eval=$(cat $destdir | grep -F 'NNUE evaluation' | grep -F '(white side)' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
final_eval=$(cat $destdir | grep -F 'Final evaluation' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')

echo "${bucket_values}"
echo "${get_used_bucket}"
echo "${classical_eval}"
echo "${nnue_eval}"
echo "${final_eval}"
