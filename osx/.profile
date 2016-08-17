## Exports
#export PS1="[\u@\[\e[0;33m\]\h \[\e[1;37m\]\W\[\e[0m\]]$ "
export PS1="[\u@\[\e[38;5;10m\]\h \[\e[1;37m\]\W\[\e[0m\]]$ "
export CLICOLOR=1
#export TERM=screen-256color
export TERM=xterm-256color
# Configure Bash History
shopt -s histappend
export HISTFILE=~/bash_history/.bash_history-`hostname`-$(date +%Y-%m-%d).log
export HISTSIZE=2000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups
export PATH=$PATH:/Users/dmonschein/dev_workspace/hss-config:/Users/dmonschein/vbin:/usr/local/opt:/usr/local/sbin

## >> ALIASES 
alias l='/usr/local/bin/gls -AlhF --color=yes --group-directories-first'
alias chss='/Users/dmonschein/vbin/i2cssh/bin/i2cssh'
alias dev='cd /Users/dmonschein/dev_workspace'
alias grep='grep --color=auto'
alias rm='rm -i'
alias lservices='systemctl list-unit-files --type=service'
alias psh='pssh -v -i -l root -h' $1 $2
alias quicksniff='tcpdump -s0 -n -w ~/$(date +%Y%m%d)-$HOSTNAME-capture.pcap -i' $1
alias walk='snmpwalk -Os -v2c -c public $1'
alias repoupdate='for mydir in ~/dev_workspace/*; do cd $mydir && git pull gold master && git push; done'
alias stat='/usr/local/bin/gstat'
alias sync='git fetch gold; git checkout master; git merge gold/master'

## >> FUNCTIONS
function ans {
export ANSIBLE_CONFIG=/Users/dmonschein/dev_workspace/ansible/config/ansible.cfg
cd /Users/dmonschein/dev_workspace/ansible
source /Users/dmonschein/vbin/ansible/hacking/env-setup
}


function genpass {
echo -n "Date + sha512sum: "
date +%s | gsha512sum | base64 | head -c 32 ; echo

echo -n "OpenSSL Random: "
openssl rand -base64 32
}

function ansupdate {
cd /Users/dmonschein/vbin/ansible
git pull --rebase
git submodule update --init --recursive
}

function file {
/usr/bin/file $1
/usr/local/bin/grealpath $1
}

function return-limits {
    
    for process in $@; do
        process_pids=`ps -C $process -o pid --no-headers | cut -d " " -f 2`
        
        if [ -z $@ ]; then
            echo "[no $process running]"
        else
            for pid in $process_pids; do
                echo "[$process #$pid -- limits]"
                cat /proc/$pid/limits
            done
        fi
        
    done
}

function my_colors {
FGNAMES=(' black ' '  red  ' ' green ' ' yellow' '  blue ' 'magenta' '  cyan ' ' white ')
BGNAMES=('DFT' 'BLK' 'RED' 'GRN' 'YEL' 'BLU' 'MAG' 'CYN' 'WHT')
echo "     ----------------------------------------------------------------------------"
for b in $(seq 0 8); do
    if [ "$b" -gt 0 ]; then
        bg=$(($b+39))
    fi

    echo -en "\033[0m ${BGNAMES[$b]} : "
    for f in $(seq 0 7); do
        echo -en "\033[${bg}m\033[$(($f+30))m ${FGNAMES[$f]} "
    done
    echo -en "\033[0m :"

    echo -en "\033[0m\n\033[0m     : "
    for f in $(seq 0 7); do
        echo -en "\033[${bg}m\033[1;$(($f+30))m ${FGNAMES[$f]} "
    done
    echo -en "\033[0m :"
    echo -e "\033[0m"

    if [ "$b" -lt 8 ]; then
        echo "     ----------------------------------------------------------------------------"
    fi
done
echo "     ----------------------------------------------------------------------------"
}

function my_colors2 {
x=`tput op` 
y=`printf %76s`
for i in {0..256}
do 
    o=00$i
    echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x
done
}
