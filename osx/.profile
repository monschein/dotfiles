## Exports

# Configure BASH Prompt
# Lime Green
export PS1='[\u@\[\033[38;5;118m\]\h \[\e[1;37m\]\w\[\e[0m\]]$ '
# Orange
#export PS1='[\u@\[\033[38;5;208m\]\h \[\e[1;37m\]\w\[\e[0m\]]$ '
# Teal
#export PS1='[\u@\[\033[38;5;14m\]\h \[\e[1;37m\]\w\[\e[0m\]]$ '
# Turqoise
#export PS1='[\u@\[\033[38;5;85m\]\h \[\e[1;37m\]\w\[\e[0m\]]$ '
# Yellow
#export PS1='[\u@\[\033[38;5;228m\]\h \[\e[1;37m\]\w\[\e[0m\]]$ '
# Purple
#export PS1='[\u@\[\033[38;5;5m\]\h \[\e[1;37m\]\w\[\e[0m\]]$ '
export CLICOLOR=1

# Colored man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Configure TERM
#export TERM=screen-256color
export TERM=xterm-256color

# Configure Bash History
export HISTFILE=~/bash_history/.bash_history-`hostname`-$(date +%Y-%m-%d).log
export HISTSIZE=1000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%d/%m/%y %T "
#export PATH=/usr/local/opt/python/libexec/bin:$PATH:/Users/dmonschein/dev_workspace/hss-config:/Users/dmonschein/personal_workspace:/usr/local/opt:/usr/local/sbin:/usr/local/opt/ruby/bin
#export PATH=$PATH:/Users/dmonschein/dev_workspace/hss-config:/Users/dmonschein/personal_workspace:/usr/local/opt:/usr/local/sbin:/usr/local/opt/ruby/bin
export PATH=/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:/Users/dmonschein/dev_workspace/hss-config:/Users/dmonschein/personal_workspace:$PATH
export JENKINS_API_KEY=yeet
export VAGRANT_DEFAULT_PROVIDER='virtualbox'
export GITHUB_URL=https://bits.linode.com/

## >> ALIASES 
alias l='/usr/local/bin/gls -AlhF --color=yes --group-directories-first'
alias agent='ssh-add /Users/dmonschein/.ssh/id_rsa'
alias bigdirs='find . -type d -exec du -Shxa {} + | sort -rh | head -n 15'
alias bigfiles='find . -type f -exec du -Shxa {} + | sort -rh | head -n 15'
alias chss='/Users/dmonschein/personal_workspace/i2cssh/bin/i2cssh --profile i2cssh'
alias dev='cd /Users/dmonschein/dev_workspace'
alias grep='grep --color=auto'
alias gsurr='git submodule update --remote --recursive'
alias grum='git rebase gold/master'
alias gfr='git fetch gold && git rebase gold/master'
alias rm='rm -i'
alias lservices='systemctl list-unit-files --type=service'
alias nmap_full='nmap -p 1-65535 -sV -sS -T4' $1
alias pipupgrade='pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U'
alias psh='pssh -v -i -l root -h' $1 $2
alias pcs='scp -S hss'
alias quicksniff='tcpdump -s0 -n -w ~/$(date +%Y%m%d)-$HOSTNAME-capture.pcap -i' $1
alias walk='snmpwalk -Os -v2c -c public $1'
alias repoupdate='for mydir in ~/dev_workspace/*; do cd $mydir && git pull gold master && git push; done'
alias saft='/Users/dmonschein/Library/Python/2.7/bin/saft'
alias stat='/usr/local/bin/gstat'
alias sync='git fetch gold; git checkout master; git merge gold/master'
alias vclean='vagrant global-status --prune'
alias cephdash='ssh -L 5000:localhost:5000 root@bs5-cjj1'
alias saltenc="gpg2 -a --encrypt -r 'Linode Sysops Salt' -r 'Linode Sysops Salt Staging'"
alias weather='curl wttr.in/08083'
alias whatslistening='ss -atpu'

## >> FUNCTIONS
function bmc {
BMCHOST=$1
USER=$2
PASS=$3
cd /Users/dmonschein/personal_workspace/smcipmitool
java -Djava.library.path=. -jar iKVM.jar $BMCHOST $USER $PASS  null 5900 2623 2 0
}

function ans {
export ANSIBLE_CONFIG=/Users/dmonschein/dev_workspace/ansible-playbooks/config/ansible.cfg
#export PATH=/Users/dmonschein/personal_workspace/ansible/bin:/Users/dmonschein/personal_workspace/ansible/test/runner:$PATH
#export PATH=/usr/bin:$PATH
cd /Users/dmonschein/dev_workspace/ansible-playbooks
source /Users/dmonschein/personal_workspace/ansible/hacking/env-setup
}

function ans_ceph {
export ANSIBLE_CONFIG=/Users/dmonschein/dev_workspace/ansible-ceph/config/ansible.cfg
cd /Users/dmonschein/dev_workspace/ansible-ceph
source /Users/dmonschein/personal_workspace/ansible/hacking/env-setup
}

function iosummary {
echo "Run these to get a good summary of current performance:"

cat << EOF
uptime
dmesg | tail
vmstat 1
mpstat -P ALL 1
pidstat 1
iostat -xz 1
free -m
sar -n DEV 1
sar -n TCP,ETCP 1
top
EOF
}

function dcls {
cat << EOF
'dal1': 2
'fnc1': 3
'atl1': 4
'cjj1': 6
'lon1': 7
'fch1': 8
'sin1': 9
'fra1': 10
'shg1': 11
'cjj2': 12
'phl1': 13
'mum1': 14
'tor1': 15
EOF
}

function grid {
mylist=$1
#chss -A -f $mylist
chss -f $mylist
}

function newlinode {
newbie=$1
ansible-playbook -v -i '$newbie,' new_linode.yml --user=root --ask-pass --ask-vault-pass
}
function genpass {
echo -n "Date + sha512sum: "
date +%s | gsha512sum | base64 | head -c 32 ; echo

echo -n "OpenSSL Random: "
openssl rand -base64 32
}

function ansupdate {
cd /Users/dmonschein/personal_workspace/ansible
git pull --rebase
git submodule update --init --recursive
}

function bsdowntime {
    DC=$1
    START=$2
    END=$3
    for i in $(eval echo "{$START..$END}"); do
        echo "@linagios downtime bs$i-$DC 1h";
    done
}

function file {
/usr/bin/file $1
/usr/local/bin/grealpath $1
}

function ntpscan {
pssh -v -i -l root -h /Users/dmonschein/dev_workspace/hostlists/ntp_hosts.txt 'ntpq -np'
}

function mysed {
# classic sed in-file string replacement. create backup file
old_string=$1
new_string=$2
myfile=$3

sed -i .bak "s/$old_string/$new_string/g" $myfile

}

function mylinodes {
    linode-cli linodes list --text | awk '{print $2, $7 }'
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


#export PATH="$HOME/.cargo/bin:$PATH"
