#!/bin/bash

#H="$(hostname)"
#echo "Arg is $1, Ran on machine $H at $(date +%s)"

#jq  '. | "\(.abstract != null)"' $1
#jq  'select(.abstract != null).abstract' $1 | /lustre/orion/stf019/proj-shared/junqi-work/nvme-switch/langdetect.pl
#jq  'select(.abstract != null).abstract, select(.fullText != null).fullText' $1 | /lustre/orion/stf019/proj-shared/junqi-work/nvme-switch/langdetect.pl | perl -C -pe 's/[^\p{ASCII}\p{Latin_1}]//g'

jq -r 'select(.abstract != null).abstract, select(.fullText != null).fullText' $1 | jq -s -R '{fullText: .}' | /lustre/orion/stf019/proj-shared/junqi-work/nvme-switch/langdetect.pl | perl -CAS -pe 's/\P{^Script: Han}//g;' -pe 's/\P{^Script: Hangul}//g;' -pe 's/\P{^Script: Cyrillic}//g;' -pe 's/\P{^Script: Hiragana}//g;' -pe 's/\P{^Script: Arabic}//g;' -pe 's/\P{^Script: Thai}//g;' | tr -s ',;".' | sed -e 's/\\n//g'

#note: tr -cs '[[:alpha:][:space:]]' ' ' < extractfromjson-1683321.out > processed.out
