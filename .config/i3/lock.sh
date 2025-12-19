#!/bin/sh

alpha='ff'
background='#282828'
selection='#282828'
comment='#6272a4'

yellow='#fabd2f'
orange='#d79921'
red='#cc241d'
magenta='#b16286'
blue='#458588'
cyan='#689d6a'
green='#98971a'

i3lock \
  --insidever-color=$selection$alpha \
  --insidewrong-color=$selection$alpha \
  --inside-color=$selection$alpha \
  --ringver-color=$green$alpha \
  --ringwrong-color=$red$alpha \
  --ringver-color=$green$alpha \
  --ringwrong-color=$red$alpha \
  --ring-color=$magenta$alpha \
  --line-uses-ring \
  --keyhl-color=$orange$alpha \
  --bshl-color=$orange$alpha \
  --separator-color=$selection$alpha \
  --verif-color=$green \
  --wrong-color=$red \
  --modif-color=$red \
  --layout-color=$blue \
  --date-color=$yellow \
  --time-color=$yellow \
  --screen 1 \
  --blur 1 \
  --clock \
  --indicator \
  --time-str="%H:%M:%S" \
  --date-str="%a %e %b %Y" \
  --verif-text="Checking..." \
  --wrong-text="Wrong pswd" \
  --noinput="No Input" \
  --lock-text="Locking..." \
  --lockfailed="Lock Failed" \
  --radius=120 \
  --ring-width=15 \
  --pass-media-keys \
  --pass-screen-keys \
  --pass-volume-keys \
  --time-font="DepartureMono Nerd Font Mono" \
  --date-font="DepartureMono Nerd Font Mono" \
  --verif-font="DepartureMono Nerd Font Mono" \
  --wrong-font="DepartureMono Nerd Font Mono" \
  --layout-font="DepartureMono Nerd Font Mono" \
