#!/bin/bash

[[ -z "${OPEN_AI_API_KEY}"  ]] && OPEN_AI_API_KEY="PUT_YOUT_OPEEN_AI_KEY_HERE" || OPEN_AI_API_KEY="${OPEN_AI_API_KEY}"

# GPT-3( text-curie-001 text-babbage-001 text-ada-001 davinci curie babbage ada) --- GPT-3.5( gpt-3.5-turbo gpt-3.5-turbo-0301 text-davinci-003 text-davinci-002 code-davinci-002) --- GPT-4(gpt-4 gpt-4-0314 gpt-4-32k gpt-4-32k-0314 )
model="gpt-3.5-turbo"
# Variation 0 = low(deterministic-ish) 1 = High Variance
temperature="0.7"

rofi_prompt() {
    echo "" | rofi -dmenu -p "ChatGPT(3.5-turbo) "
}

# bash bash-gpt.sh, uses rofi
if [[ "$1" == "" ]]; then
    query=$( rofi_prompt )
    query=$( echo "$query" | tr '\"' '`' )

    # BUGFIX: Avoid empty queries
    if [[ "$query" = "" ]]; then
        exit 1
    fi

    result=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPEN_AI_API_KEY" \
        -d "{
            \"model\": \"$model\",
            \"messages\": [{ \"role\": \"user\", \"content\": \"Avoid giving answers with triple backsticks. You answer should not be in markdown, nor should it include backsticks. Follow the Intructions: $query\" }],
            \"temperature\": $temperature
        }" | jq '.choices[0].message.content' )

    result=$( echo "$result" | sed 's/\\n//g' )
        rofi -e "$result"

    # Copy to clipboard & Talk
    echo "$result" | xclip -selection clipboard
    espeak -s 300 "$result"

else # bash gpt.sh "List me 2 games"
    query="$1"

    result=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPEN_AI_API_KEY" \
        -d "{
            \"model\": \"$model\",
            \"messages\": [{ \"role\": \"user\", \"content\": \"$query\" }],
            \"temperature\": $temperature
        }" | jq '.choices[0].message.content' )

    # Copy to clipboard & Talk
    result=$( echo "$result" | sed 's/\\n//g' )
    espeak -s 300 "$result"
fi
