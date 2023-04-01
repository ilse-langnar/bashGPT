#!/bin/bash

[[ -z "${OPEN_AI_API_KEY}"  ]] && OPEN_AI_API_KEY="IF_YOU_DONT_HAVE_A_ENV_VARIABLE_PUT_YOUR_OPEN_AI_KEY_HERE" || OPEN_AI_API_KEY="${OPEN_AI_API_KEY}"


model="gpt-3.5-turbo" # GPT-3( text-curie-001 text-babbage-001 text-ada-001 davinci curie babbage ada) --- GPT-3.5( gpt-3.5-turbo gpt-3.5-turbo-0301 text-davinci-003 text-davinci-002 code-davinci-002) --- GPT-4(gpt-4 gpt-4-0314 gpt-4-32k gpt-4-32k-0314 )
temperature="0.7" # Variation 0 = low(deterministic-ish) 1 = High Variance


# ---------------------------> Rofi <--------------------------- #
rofi_prompt() {
    echo "" | rofi -dmenu -location 0 -i --fixed-num-lines -width 70 -show-icons -show run -config config.rasi -sidebar-mode -kbclear-line "Mod3+Control+u" -kb-secondary-paste "Mod3+Control+v" -kb-clear-line "Mod3+Control+u" -kb-move-front "Mod3+Control+a" -kb-move-end "Mod3+Control+e" -kb-move-word-back "Mod3+Alt+b" -kb-move-word-forward "Mod3+Alt+f" -kb-move-char-back "Mod3+Left" -kb-move-char-forward "Mod3+Right" -kb-remove-word-back "Mod3+Control+Alt+h" -kb-remove-word-forward "Mod3+Control+Alt+d" -kb-remove-char-forward "Mod3+Delete" -kb-remove-char-back "Mod3+BackSpace,Mod3+Shift+BackSpace,Mod3+Control+BackSpace" -kb-accept-entry "Mod3+Return" -kb-accept-entry-continue "Mod3+Shift+Return" -kb-mode-next "Mod3+Shift+Tab" -kb-mode-previous "Mod3+Shift+Control+Tab" -kb-toggle-case-sensitivity "Mod3+grave" -kb-delete-entry "Mod3+Shift+Delete" -kb-row-left "Mod3+Control+Page_Up" -kb-row-right "Mod3+Control+Page_Down" -kb-row-up "Mod3+Up" -kb-row-down "Mod3+Down" -kb-row-tab "Mod3+Tab" -kb-page-prev "Mod3+Page_Up" -kb-page-next "Mod3+Page_Down" -kb-row-first "Mod3+Home" -kb-row-last "Mod3+End" -kb-row-select "Mod3+Control+space" -kb-cancel "Mod3+Escape" -kb-custom-1 "Mod3+Alt+1" -kb-custom-2 "Mod3+Alt+2" -kb-custom-3 "Mod3+Alt+3" -kb-custom-4 "Mod3+Alt+4" -kb-custom-5 "Mod3+Alt+5" -kb-custom-6 "Mod3+Alt+6" -kb-custom-7 "Mod3+Alt+7" -kb-custom-8 "Mod3+Alt+8" -kb-custom-9 "Mod3+Alt+9" -kb-custom-10 "Mod3+Alt+0" -kb-custom-11 "Mod3+Alt+Shift+1" -kb-custom-12 "Mod3+Alt+Shift+2" -kb-custom-13 "Mod3+Alt+Shift+3" -kb-custom-14 "Mod3+Alt+Shift+4" -kb-custom-15 "Mod3+Alt+Shift+5" -kb-custom-16 "Mod3+Alt+Shift+6" -kb-custom-18 "Mod3+Alt+Shift+8" -kb-custom-17 "Mod3+Alt+Shift+7" -kb-custom-19 "Mod3+Alt+Shift+9"
}
# ---------------------------> Rofi <--------------------------- #

# bash bash-gpt.sh, uses rofi
if [[ "$1" == "" ]]; then
    query=$( rofi_prompt )
    query=$( echo "$query" | tr '\"' '`' )

    result=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPEN_AI_API_KEY" \
        -d "{
            \"model\": \"$model\",
            \"messages\": [{ \"role\": \"user\", \"content\": \"$query\" }],
            \"temperature\": $temperature
        }" | jq '.choices[0].message.content' )


    result=$( echo "$result" | sed 's/\\n//g' )
        rofi -e "$result"

    echo "$result" | xclip -selection clipboard # Copy to clipboard

else # bash bash-gpt.sh "List me 2 games"
    query="$1"

    result=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPEN_AI_API_KEY" \
        -d "{
            \"model\": \"$model\",
            \"messages\": [{ \"role\": \"user\", \"content\": \"$query\" }],
            \"temperature\": $temperature
        }" | jq '.choices[0].message.content' )
    result=$( echo "$result" | sed 's/\\n//g' )
    echo "$result"

    echo "$result" | xclip -selection clipboard # Copy to clipboard
fi
