#!/bin/bash

jq -r 'select(.abstract != null).abstract, select(.fullText != null).fullText' $1 | jq -s -R '{fullText: .}' | /lustre/orion/stf019/proj-shared/junqi-work/nvme-switch/langdetect.pl | perl -CAS -pe 's/\P{^Script: Han}//g;' -pe 's/\P{^Script: Hangul}//g;' -pe 's/\P{^Script: Cyrillic}//g;' -pe 's/\P{^Script: Hiragana}//g;' -pe 's/\P{^Script: Arabic}//g;' -pe 's/\P{^Script: Thai}//g;' | tr -s ',;".' | sed -e 's/\\n//g'

