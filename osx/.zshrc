## Exports

# set zsh prompt
export PROMPT="[%n@%B%F{green}%m %B%F{white}%~%b%F{reset_color}]$ "
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
export TERM=xterm-256color
export BASH_SILENCE_DEPRECATION_WARNING=1

# Configure Bash History - BASH ONLY
#export HISTFILE=~/bash_history/.bash_history-$(hostname)-$(date +%Y-%m).log
#export HISTSIZE=10000
#export HISTFILESIZE=100000
#export HISTCONTROL=ignoredups

# Configure zsh history - zsh only
HISTFILE=~/bash_history/.bash_history-$(hostname)-$(date +%Y-%m).log
HISTSIZE=10000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS       # Ignore duplicate commands
setopt EXTENDED_HISTORY       # Record timestamp of command in history

export HISTTIMEFORMAT='%F %T '
export PATH=/opt/homebrew/bin:/opt/homebrew/opt/ruby/bin:/Users/dmonsche/dev_workspace/hss-config:/Users/dmonsche/.local/bin:/Users/dmonsche/go/bin:$PATH
export VAGRANT_DEFAULT_PROVIDER='virtualbox'

# Homebrew environment
eval "$(/opt/homebrew/bin/brew shellenv)"

# Go env
export GOPATH=$HOME/go

## >> ALIASES 
alias l='gls -AlhF --color=yes --group-directories-first'
alias agent='ssh-add /Users/dmonsche/.ssh/id_rsa'
alias bigdirs='find . -type d -exec du -Shxa {} + | sort -rh | head -n 15'
alias bigfiles='find . -type f -exec du -Shxa {} + | sort -rh | head -n 15'
alias chss='i2cssh --shell zsh'
alias devhss='HSS_CONFIG=~/dev_workspace/hss-config/devc.yml hss $1'
alias grep='grep --color=auto'
alias gsurr='git submodule update --remote --recursive'
alias grum='git rebase gold/main'
alias gfr='git fetch gold && git rebase gold/main'
alias rm='rm -i'
alias lservices='systemctl list-unit-files --type=service'
alias nmap_full='nmap -p 1-65535 -sV -sS -T4' $1
alias penv='source /Users/dmonsche/dave_bin/venv/bin/activate'
alias pipupgrade='pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U'
alias psh='pssh -v -i -l root -h' $1 $2
alias pcs='scp -S hss'
alias quicksniff='tcpdump -s0 -n -w ~/$(date +%Y%m%d)-$HOSTNAME-capture.pcap -i' $1
alias walk='snmpwalk -Os -v2c -c public $1'
alias gitreset='git reset --hard gold/main; git push origin main --force'
alias stat='/opt/homebrew/bin/gstat'
alias sync='git fetch gold; git checkout master; git merge gold/master'
alias s3public='s3cmd setacl --acl-public' $1
alias s3private='s3cmd setacl --acl-public' $1
alias s5cmd='s5cmd --endpoint-url https://us-east-1.linodeobjects.com'
alias vclean='vagrant global-status --prune'
alias weather='curl wttr.in/08083'
alias whatslistening='ss -atpu'

## >> Bash specific Tweaks
# Turn on recursive globbing (enables ** to recurse all directories)
#shopt -s globstar 2> /dev/null

# Correct spelling errors during tab-completion
#shopt -s dirspell 2> /dev/null

# Correct spelling errors in arguments supplied to cd
#shopt -s cdspell 2> /dev/null

# Zsh specific Tweaks

# Turn on recursive globbing (enables ** to recurse all directories)
setopt globstarshort

# Correct spelling errors during tab-completion
#setopt correct

# Correct spelling errors in arguments supplied to cd
#setopt correct_all

## >> FUNCTIONS
function rotate_ssh_keys() {
  mkdir -p ~/.ssh/old
  timestamp=$(date +%m-%d-%y)
  if [[ -f ~/.ssh/id_rsa || -f ~/.ssh/id_rsa.pub ]]; then
    mv -v ~/.ssh/id_rsa ~/.ssh/old/id_rsa_$timestamp
    mv -v ~/.ssh/id_rsa.pub ~/.ssh/old/id_rsa_$timestamp.pub
  fi
  echo "Generating new SSH key"
  ssh-keygen -t rsa -b 4096 -C "dmonsche@monsche.in"
  echo "Copying new key to personal machines"
  ssh-copy-id -f -i ~/.ssh/id_rsa.pub -o "IdentityFile=~/.ssh/old/id_rsa_$timestamp" dmonschein@server
  ssh-copy-id -f -i ~/.ssh/id_rsa.pub -o "IdentityFile=~/.ssh/old/id_rsa_$timestamp" dmonschein@server
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

function grid {
mylist=$1
chss -f $mylist
}

function newlinode {
newbie=$1
ansible-playbook -v -i '$newbie,' new_linode.yml --user=root --ask-pass --ask-vault-pass
}

function genpass {
echo -n "Generating a random password using OpenSSL (Base64): "
openssl rand -base64 40

echo -n "/dev/urandom graph: "
LC_CTYPE=C tr -dc "[:graph:]" < /dev/urandom | fold -w 40 | head -n 1

echo -n "date plus sha512sum: "
date +%s | gsha512sum | base64 | head -c 32 ; echo
}

function file {
/usr/bin/file $1
/opt/homebrew/bin/grealpath $1
}

function cheat {
    curl cheat.sh/$1
}


function mysed {
# classic sed in-file string replacement. create backup file
old_string=$1
new_string=$2
myfile=$3

sed -i .bak "s/$old_string/$new_string/g" $myfile

}

function mylinodes {
    linode-cli linodes list --text | awk '{print $7, $2 }'
}

function gen-ceph-key { 
    python -c "import os ; import struct ; import time; import base64 ; key = os.urandom(16) ; header = struct.pack('<hiih',1,int(time.time()),0,len(key)) ; print base64.b64encode(header + key)"
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
