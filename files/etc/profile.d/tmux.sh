test_continue()
{
    echo "Run $1 now?"
    read answer
    if [ $answer = y -o $answer = Y ]; then
        echo "Launching $1"
        eval $1
    else
        echo "Not doing $1"
    fi
}

echo $PATH | grep -q tmuxifier || export PATH="$PATH:/root/tmuxifier/bin"
export TMUXIFIER_LAYOUT_PATH="/etc/tmux-layouts"

if [ -z "${TMUX}" -a -n "${SSH_CONNECTION}" ]; then
    if [ -n "$( pgrep tmux )" ]; then
        test_continue "tmux attach"
    else
        test_continue "tmux -2u"
    fi
fi
