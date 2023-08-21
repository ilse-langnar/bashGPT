#!/bin/bash

[[ -z "${OPEN_AI_API_KEY}"  ]] && OPEN_AI_API_KEY="PUT_YOUT_OPEEN_AI_KEY_HERE" || OPEN_AI_API_KEY="${OPEN_AI_API_KEY}"

# GPT-3( text-curie-001 text-babbage-001 text-ada-001 davinci curie babbage ada) --- GPT-3.5( gpt-3.5-turbo gpt-3.5-turbo-0301 text-davinci-003 text-davinci-002 code-davinci-002) --- GPT-4(gpt-4 gpt-4-0314 gpt-4-32k gpt-4-32k-0314 )
model="gpt-3.5-turbo"
# Variation 0 = low(deterministic-ish) 1 = High Variance
temperature="0.7"

rofi_prompt() {
    echo "" | rofi -dmenu -p "ChatGPT(3.5-turbo) "
}

add_history() {
    question="$1"
    answer="$2"
    echo "$question: $answer" >> $HOME/.bashgpt_history
}

if [[ "$1" == "" ]]; then
    # bash gpt.sh, uses rofi
    question=$( rofi_prompt )
    question=$( echo "$question" | tr '\"' '`' )

    # BUGFIX: Avoid empty queries
    if [[ "$question" = "" ]]; then
        exit 1
    fi

    answer=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPEN_AI_API_KEY" \
        -d "{
            \"model\": \"$model\",
            \"messages\": [{ \"role\": \"user\", \"content\": \"Avoid giving answers with triple backsticks. You answer should not be in markdown, nor should it include backsticks. Follow the Intructions: $question\" }],
            \"temperature\": $temperature
        }" | jq '.choices[0].message.content' )

    answer=$( echo "$answer" | sed 's/\\n//g' ) # Removes newlines(will change)

    rofi -e "$answer" # display
    echo "$answer" | xclip -selection clipboard # copy to clipboard
    espeak -s 300 "$answer"
    add_history "$question" "$answer"

elif [[ "$1" == "@history" ]]; then
    # bash gpt.sh "history"; # open your history
    
    selected=$(cat "$HOME/.bashgpt_history" | rofi -dmenu -p "ChatGPT History: ")
    echo "$selected" | xclip -selection clipboard # copy to clipboard

else
    # bash gpt.sh "List me 2 games"; # 1. <game> 2. <game>
    question="$1"

    answer=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPEN_AI_API_KEY" \
        -d "{
            \"model\": \"$model\",
            \"messages\": [{ \"role\": \"user\", \"content\": \"$question\" }],
            \"temperature\": $temperature
        }" | jq '.choices[0].message.content' )


    answer=$( echo "$answer" | sed 's/\\n//g' ) # Removes newlines(will change)
    echo "$answer" | xclip -selection clipboard # copy to clipboard
    espeak -s 300 "$answer"
    add_history "$question" "$answer"
    echo $answer
fi
