alias cd1="cd /home/yournick/code/src/gitlab.1touch.corp/configuration/1touch-release-rbac/scripts/tools/test_installer"
alias cd2="cd /home/yournick/code/src/gitlab.1touch.corp/configuration/1touch-release-rbac/scripts/tools/test_installer/tmp2/install/.gitlab-ci"
alias cd3="cd /home/yournick/code/src/gitlab.1touch.corp/configuration/helm_info"

[ -e ~/.bash_complete_alias ] && source ~/.bash_complete_alias
[ -e ~/.bash_aliases_git    ] && source ~/.bash_aliases_git
[ -e ~/.bash_aliases_docker ] && source ~/.bash_aliases_docker
[ -e ~/.bash_aliases_k8s    ] && source ~/.bash_aliases_k8s

######################################################
alias c='clear'
alias r='reset'

alias sudop='sudo env PATH=$PATH'

alias rgi='rg -i'
alias rgn='rg --hidden --no-ignore'
complete -F _complete_alias rgn

alias catb='bat'
alias cats='bat -A'
alias catc='bat -p'
alias catn='bat -n'

alias fix_term='printf "\e[?2004l"'

alias logout='mate-session-save --logout'

alias w_PWD='basename $PWD'

alias smcedit='sudo mcedit'
alias logmysql='tail -f /var/log/mysql/error.log -f /var/log/mysql/mysql-slow.log'
alias err='echo -------------; tail -n 30 -f /var/log/mysql/error.log  -n 30 -f ~/sites/var/log/error_local.log -n 30 -f ~/sites/var/log/error_IP.log -n 30 -f ~/sites/var/log/error_localhost.log'

alias cdadm='cd; cd ~/work'
alias cdww='cd;  cd ~/sites/var/www'
alias cdwd='cd;  cd ~/sites/var/dockers'
alias cdwp='cd;  cd ~/projects'
alias cdw1='cd;  cd ~/code/src'
alias cderr='cd; cd ~/sites/var/log'
alias cdz='cd; cd ~/Downloads'
alias cds='cd; cd ~/Sync'
alias cdl='cd; cd ~/lib'
alias cdt='cd; cd ~/tmp'
alias cdb='cd; cd ~/bin'
alias cdd='cd; cd ~/Docs/tech'
alias cddr='cd; cd ~/Dropbox'
alias s_bashrc='source ~/.bashrc'
#alias etsys='ssh etsys'

##--------------http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

alias apt-get='sudo apt-get'
alias dpkg='sudo dpkg'
alias apt='sudo apt'
alias ag='ag --hidden'
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

function _cd_by_filename() {
    local d=$(dirname "$@")
    echo "cd \"$d\""
    cd "$d"
}

alias man_uk='man -Luk'
alias man_ru='man -Lru'
alias _cd_f=_cd_by_filename
alias venv_activate='[ -d venv ] && source venv/bin/activate || source'
alias lint_bash='rg "\[\s+[^]]+\S[!=]{0,1}[=]{1,2}[~]{0,1}\S.*\s+\]"'
