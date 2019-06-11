# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
#window_root "/var/www/localhost/htdocs/nnplus/misc/update_scripts/"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window
#"newznab"

# Split window into panes.
split_v 50
select_pane 0
split_h 50
select_pane 2
split_h 50
select_pane 3

run_cmd "eval \`resize\`" 0
run_cmd "cler" 0
run_cmd "htop" 0
run_cmd "eval \`resize\`" 1
run_cmd "logread" 1
run_cmd "logread -f" 1
run_cmd "eval \`resize\`" 2
run_cmd "clear" 2
run_cmd "iperf3 -s" 2
run_cmd "eval \`resize\`" 3
run_cmd "clear" 3

## Set active pane.
select_pane 3
