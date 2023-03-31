#!/bin/bash

[[ -z "${OPEN_AI_API_KEY}"  ]] && OPEN_AI_API_KEY="IF_YOU_DO_NOT_HAVE_A_ENV_VARIABLE_PASTE_YOUR_OPEN_AI_KEY_HERE" || OPEN_AI_API_KEY="${OPEN_AI_API_KEY}"

model="gpt-3.5-turbo" # GPT-3( text-curie-001 text-babbage-001 text-ada-001 davinci curie babbage ada) --- GPT-3.5( gpt-3.5-turbo gpt-3.5-turbo-0301 text-davinci-003 text-davinci-002 code-davinci-002) --- GPT-4(gpt-4 gpt-4-0314 gpt-4-32k gpt-4-32k-0314 )
temperature="0.7" # Variation 0 = low(deterministic-ish) 1 = High Variance


# ---------------------------> Rofi <--------------------------- #
rofi_prompt() {
    echo "" | rofi -dmenu -location 0 -i --fixed-num-lines -width 70 -show-icons -show run -config config.rasi -sidebar-mode -kbclear-line "Control+u" -kb-secondary-paste "Control+v" -kb-clear-line "Control+u" -kb-move-front "Control+a" -kb-move-end "Control+e" -kb-move-word-back "Alt+b" -kb-move-word-forward "Alt+f" -kb-move-char-back "Left" -kb-move-char-forward "Right" -kb-remove-word-back "Control+Alt+h" -kb-remove-word-forward "Control+Alt+d" -kb-remove-char-forward "Delete" -kb-remove-char-back "BackSpace,Shift+BackSpace,Control+BackSpace" -kb-accept-entry "Return" -kb-accept-entry-continue "Shift+Return" -kb-mode-next "Shift+Tab" -kb-mode-previous "Shift+Control+Tab" -kb-toggle-case-sensitivity "grave" -kb-delete-entry "Shift+Delete" -kb-row-left "Control+Page_Up" -kb-row-right "Control+Page_Down" -kb-row-up "Up" -kb-row-down "Down" -kb-row-tab "Tab" -kb-page-prev "Page_Up" -kb-page-next "Page_Down" -kb-row-first "Home" -kb-row-last "End" -kb-row-select "Control+space" -kb-cancel "Escape" -kb-custom-1 "Alt+1" -kb-custom-2 "Alt+2" -kb-custom-3 "Alt+3" -kb-custom-4 "Alt+4" -kb-custom-5 "Alt+5" -kb-custom-6 "Alt+6" -kb-custom-7 "Alt+7" -kb-custom-8 "Alt+8" -kb-custom-9 "Alt+9" -kb-custom-10 "Alt+0" -kb-custom-11 "Alt+Shift+1" -kb-custom-12 "Alt+Shift+2" -kb-custom-13 "Alt+Shift+3" -kb-custom-14 "Alt+Shift+4" -kb-custom-15 "Alt+Shift+5" -kb-custom-16 "Alt+Shift+6" -kb-custom-18 "Alt+Shift+8" -kb-custom-17 "Alt+Shift+7" -kb-custom-19 "Alt+Shift+9"
}
# ---------------------------> Rofi <--------------------------- #

# bash bash-gpt.sh, uses rofi
if [[ "$1" == "" ]]; then
    query=$( rofi_prompt )

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

    echo "$list" | xclip -selection clipboard # Copy to clipboard

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

    echo "$list" | xclip -selection clipboard # Copy to clipboard
fi
