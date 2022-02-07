function fish_prompt
    # Save variables before they are gone
    set "STATUS" $status
    set "UID" (id -u)


    # User name
    switch ~
    case "/root"
        # Root
        set_color brred
    case "/srv/*"
        # System account
        set_color brpurple
    case "/home/*"
        # Regular user
        set_color brgreen
    case "*"
        # Temporary account
        set_color brcyan
    end
    echo -n "$USER"


    # Jobs
    set "JOBSCOUNT" (jobs | count)
    if test $JOBSCOUNT -ge 1
        set_color brmagenta
        echo -n "&$JOBSCOUNT"
    end
    

    # @
    set_color normal
    echo -n "@"


    # Hostname
    set -g "CURRENT_IP" (who -m | awk '{print $5}')

    if test -z "$CURRENT_IP"
        set -g "CURRENT_IP" (who | grep "$USER" | awk '{print $5}')
    end

    if test -z "$CURRENT_IP"
        set -g "CURRENT_IP" (who | grep "$SUDO_USER" | awk '{print $5}')
    end

    if test -z "$CURRENT_IP"
        set_color green
    else if test "$CURRENT_IP" "=" "(:0)"
        set_color brgreen
    else if string match --regex '\(.+\)' "$CURRENT_IP"
        set_color cyan
    else
        set_color green
    end

    echo -n (prompt_hostname)


    # :
    set_color normal
    echo -n ":"


    # Current working directory
    if not test -e "$PWD"
        set_color brblack
    else if not test -x .
        set_color white
    else if not test -r .
        set_color white
    else if not test -w .
        set_color yellow
    else
        set_color brblue
    end
    echo -n (prompt_pwd)


    # Exit status
    if test $STATUS -ne 0
        set_color brred
        echo -n "[$STATUS]"
    end
    set_color normal


    # Dollar
    set_color --bold white
    if test "$UID" -eq 0
        echo -n "# "
    else
        echo -n "\$ "
    end
    set_color normal
end
