grim -g \
  "$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" \
  $(xdg-user-dir PICTURES)/screenshot-$(date +%Y-%m-%d-%H:%M:%S).png - | wl-copy
