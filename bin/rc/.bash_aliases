if [ -f ~/.bash_aliases_git ]; then
    . ~/.bash_aliases_git
fi

if [ -f ~/.bash_aliases_docker ]; then
    . ~/.bash_aliases_docker
fi

######################################################

alias catb='bat'
alias cats='bat -A'
alias catc='bat -p'
alias catn='bat -n'

alias fix_term='printf "\e[?2004l"'

alias logout='mate-session-save --logout'

alias w_PWD='basename $PWD'
alias w_CBR='git cbr'

alias smcedit='sudo mcedit'
alias logmysql='tail -f /var/log/mysql/error.log -f /var/log/mysql/mysql-slow.log'
alias err='echo -------------; tail -n 30 -f /var/log/mysql/error.log  -n 30 -f ~/sites/var/log/error_local.log -n 30 -f ~/sites/var/log/error_IP.log -n 30 -f ~/sites/var/log/error_localhost.log'

alias cdadm='cd; cd ~/work'
alias cdww='cd;  cd ~/sites/var/www'
alias cdwd='cd;  cd ~/sites/var/dockers'
alias cdwp='cd;  cd ~/projects'
alias cderr='cd; cd ~/sites/var/log'
alias cdz='cd; cd Downloads'
alias cdl='cd; cd ~/lib'
alias cdt='cd; cd ~/tmp'
alias cdb='cd; cd ~/bin'
alias cdd='cd; cd ~/Docs'
alias cddr='cd; cd ~/Dropbox'
alias s_bashrc='source ~/.bashrc'
#alias etsys='ssh etsys'

##--------------http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

alias apt-get='sudo apt-get'
alias apt='sudo apt'
alias grep=grep --color=auto
alias gr="echo \'grep --exclude-dir=.git --color=auto -rnP\' ; grep --exclude-dir=.git --color=auto -rnP"

#function m2(){
#  echo "grep --color=auto -rP $* ."
#  grep --color=auto -rP $* .
#}

#alias gr='grep -PRnf - . <<<'


# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
    alias reboot='sudo reboot'
#    alias update='sudo apt-get upgrade'
fi


## Colorize the ls output ##
alias ls='ls --color=auto'
## Use a long listing format ##
alias ll='ls -la'
## Show hidden files ##
alias l.='ls -d .* --color=auto'

#4: Generate sha1 digest
alias sha1='openssl sha1'

#5: Create parent directories on demand
alias mkdir='mkdir -pv'

#6: Colorize diff output
alias diff='colordiff'

#7: Make mount command output pretty and human readable format
alias mount='mount |column -t'

# become root #
alias root='sudo -i'

## set some other defaults ##
alias df1='df -H'
alias du1='du -ch -d 1'
alias du_m1='du -hsx * | sort -rh | head -10'
alias du_m2='du -ch * | sort -rh | head -10'

## get rid of command not found ##
alias cd..='cd ..'
## a quick way to get out of current directory ##
alias ..='cd ..'
