#!/bin/bash

set -e
set -u
#set -x

suffix=".local"
ip="127.1.0.1"
hosts_file='/etc/hosts'

g_suffix=$suffix
new_host="$(echo ${PWD##*/}${suffix})"
new_ip=$ip

cnt=$(echo `grep -P "\s\b${new_host}\b" ${hosts_file} | wc -l `)

c_err='\033[1;31m'
c_warn='\033[1;35m'
c_inf='\033[1;36m'
c_cmd='\033[1;32m'
c_clr='\033[0m'

print_help(){
  echo
  echo -e "${c_err}Usage: ${0##*/} [parameter]
Parameters:
  -h              : Help
  -l              : Filtered hosts by name of current directory and default suffix.
  -l text         : Filtered hosts by 'text'
  -a              : Add host with name as current directory and default suffix and default ip
  -a host_name    : Add host with host_name and default ip
  -a host_name ip : Add host with host_name and ip
  -d [host_name]  : Remove host for current directory or 'host_name'

Default:
  ip: ${ip}
  suffix: ${g_suffix}
${c_clr}"
}

echo_color() {
  mess=${1:-''}
  color=${2:-$c_inf}
  echo -e "${color}${mess}${c_clr}"
}

echo_info() {
  mess=${1:-''}
  insert_empty_line_before=${2:-0}
  insert_empty_line_after=${3:-0}
  color=${4:-$c_inf}
  [ -z "$insert_empty_line_before" -o "$insert_empty_line_before" == '0' ] || echo
  echo_color "$mess" $color
  [ -z "$insert_empty_line_after" -o "$insert_empty_line_after" == '0' ] || echo
}

echo_cmd() {
  mess=${1:-''}
  insert_empty_line_before=${2:-1}
  insert_empty_line_after=${3:-0}
  color=${4:-$c_cmd}
  echo_info "$mess" $insert_empty_line_before $insert_empty_line_after $color
}

exit_if_error() {
  local status=${1:-0}
  local mess=$(2:-'please check')
  if [ "$s" != '0' ]; then 
    echo_color "Error: $mess" $c_err
    exit $status
  fi
}

get_host() {
  local l_host=${1:-$new_host}
  local exact=${2:-1}
  if [ "$exact" == '1' ]; then 
    grep -E "\\s$l_new_host(\\s|\$)" "$hosts_file"
  else
    grep -wF "$l_new_host" "$hosts_file"
  fi
}

print_all_hosts() {
  local FOUND
  echo_info 'All hosts' 1 0 $c_inf
  if [ "$suffix" = '' ]; then
    FOUND=$( cat "$hosts_file" )
  else
    FOUND=$( cat "$hosts_file" | grep -P "${suffix}\b" )
  fi
  echo_info "$FOUND" 0 0 $c_cmd
}

print_similar_hosts() {
  local l_new_host=${1:-$new_host}
  local l_show_exact=${2:-0}

  local l_similars_host=$(get_host "$l_new_host" "$l_show_exact")
  if [ -n "$l_similars_host" ] ; then
    if [ "$l_show_exact" == '1' ] ; then 
      echo_info "Existing host:" 1 0 $c_warn 
    else
      echo_info "Similar '$l_new_host' hosts exist:" 1 0 $c_warn 
    fi
    echo_info "$l_similars_host" 0 0 $c_inf
  else
    echo_info "Cannot find hosts similar '$l_new_host'\n" 1 0 $c_warn
  fi
}

_add() {
  local l_new_host=${2:-$new_host}
  local l_new_ip=${3:-$new_ip}

  local l_exists_host=$(get_host "$l_new_host" 1)
  if [ -n "$l_exists_host" ]; then
    echo_info "The host '$l_new_host' already exists" 1 0 $c_warn
  else
    sudo sed -i -e '$a\' $hosts_file || sudo sh -c "echo >> $hosts_file"
    sudo sh -c "echo ${l_new_ip} ${l_new_host} >> $hosts_file" || exit 1

    echo_info "The host '$l_new_host' was added" 1 0 $c_warn
  fi
  print_similar_hosts "$l_new_host" 1
}

_remove() {
  local l_new_host=${2:-$new_host}

  local l_exists_host=$(get_host "$l_new_host" 1)
  if [ -n "$l_exists_host" ]; then
    print_similar_hosts "$l_new_host" 1
    sudo sed -r -i "/\s${l_new_host}(\s|$)/d" ${hosts_file}
    echo_info "The host '$l_new_host' was removed" 1 0 $c_warn
  else
    print_similar_hosts "$l_new_host" 0
    echo_info "The host '$l_new_host' not exists" 1 0 $c_err
  fi
}

_list() {
  local l_new_host=${2:-$new_host}
  print_similar_hosts "$l_new_host" 0
}

proces_input_params() {
  while getopts ":hlLad" opt; do
    case $opt in
      l)
        [ $# -gt 1 ] && suffix= 
        _list $*
        ;;
      a)
        [ $# -gt 1 ] && suffix=
        _add $*
        ;;
      d)
        _remove $*
        ;;
      h|*)
        suffix=
        print_all_hosts
#        _list
        print_help
        exit 0
        ;;
    esac
  done
  shift $(( OPTIND - 1 ))
}

if [ $# -eq 0 ]; then
  proces_input_params -h
fi

if [ ${1:0:1} != '-' ]; then
  proces_input_params -h
fi

proces_input_params $*
exit 0
