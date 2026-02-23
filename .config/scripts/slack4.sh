#!/bin/bash

CONVERSATION="jc."  
CHECK_INTERVAL=60                             # Vérifie toutes les 60 secondes
INACTIVITY_THRESHOLD=15                      # 5 minutes d'inactivité

# Fonction pour vérifier et changer la conversation Slack SANS perturber ton travail
change_slack_conversation() {
    # 1. Vérifie si Slack est ouvert (sans l'activer)
    SLACK_WINDOW=$(wmctrl -l | grep "Slack" | awk '{print $1}')
    if [[ -z "$SLACK_WINDOW" ]]; then
        echo "[$(date)] Slack n'est pas ouvert" >> /tmp/slack_focus.log
        return
    fi

    # 2. Récupère le titre de la fenêtre Slack (sans la focus)
    SLACK_TITLE=$(xdotool getwindowname "$SLACK_WINDOW" 2>/dev/null)

    # 3. Vérifie si c'est un DM ET pas déjà la bonne conversation
    if [[ "$SLACK_TITLE" =~ "message direct" ]] && [[ ! "$SLACK_TITLE" =~ "$CONVERSATION" ]]; then
        # 4. Stocke la fenêtre active actuelle pour y revenir après
        CUR_WINDOW=$(xdotool getactivewindow 2>/dev/null)
        CUR_TITLE=$(xdotool getwindowname "$CUR_WINDOW" 2>/dev/null)

        # 5. Change la conversation Slack
        wmctrl -i -a "$SLACK_WINDOW"  # Active Slack (discrètement)
        sleep 0.3
        xdotool key Ctrl+k
        sleep 0.2
        xdotool type "$CONVERSATION"
        sleep 0.2
        xdotool key Return
        sleep 0.5

        # 6. Reviens à la fenêtre originale (ton travail)
        wmctrl -i -a "$CUR_WINDOW" 2>/dev/null

        echo "[$(date)] Changé Slack de '$SLACK_TITLE' vers '$CONVERSATION'" >> /tmp/slack_focus.log
    fi
}

# Boucle principale (seulement si inactif)
while true; do
    LAST_INPUT=$(xprintidle 2>/dev/null)
    if (( LAST_INPUT > INACTIVITY_THRESHOLD * 1000 )); then
        change_slack_conversation
    fi
    sleep "$CHECK_INTERVAL"
done

