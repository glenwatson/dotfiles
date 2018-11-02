#!/bin/bash
# ==alias autocomplete== http://ubuntuforums.org/showthread.php?t=733397
# ==alias==
alias cd..="cd .." # I often make this mistake
# Because sometimes you don't have the time to put this two letters
alias ..='cd ..'
alias ...='cd ../..'
# =git=
# __git_complete broke :(
function __git_complete() { :
}
alias ga='git add'
__git_complete ga _git_add
alias gb='git branch'
__git_complete gb _git_branch
alias gco='git checkout'
__git_complete gco _git_checkout
alias gc='git commit'
__git_complete gc _git_commit
alias gd='git diff'
__git_complete gd _git_diff
alias gdw='git diff --color-words'
__git_complete gdw _git_diff
alias gdc='git diff --cached'
__git_complete gdc _git_diff
alias gdcw='git diff --cached --color-words'
__git_complete gdcw _git_diff
alias gs='git status'
alias gst='git stash'
__git_complete gst _git_stash
alias gstl='git stash list'
__git_complete gstl _git_stash
alias gsh='git show'
__git_complete gsh _git_show
alias gshst='git show stash@{0}' #What is at the top of my stash?
alias glna='git log --graph --abbrev-commit --decorate --date=relative --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an (%cn)%C(reset)%C(bold yellow)%d%C(reset)"'
__git_complete glna _git_log
alias gltime='git log --pretty=format:"%ad (%an) %cd (%cn) %h %s" --graph'
__git_complete gltime _git_log
alias gl='glna --all'
__git_complete gl _git_log
alias gla='gl'
__git_complete gla _git_log
alias gls='git ls-files'
__git_complete gls _git_ls_files
alias gdf='git diff-tree --stat -R -B -C'
alias gn='git notes'
__git_complete gn _git_notes
alias cdgit='cd $(git rev-parse --show-toplevel)'
# Git Diff Head. Show the difference between HEAD and when the current branch was created off of master.
# NOTE: Only works when you branched from master (one way or another)
alias gdh='git diff $(git merge-base master HEAD) HEAD'
function gf() {
	#git log --oneline --decorate --all --format=format:"%C(bold blue)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" | grep ${1}
	git log --oneline --decorate --grep="${1}"
}
function gud() {
	gst
	gco $1
	git pull origin $1
}
function gshno() {
	gsh --name-only $1
}
function git_lines_contributed() {
	git log --author="$1" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
}
function git_fake() {
	read -p GIT_AUTHOR_NAME= NAME
	read -p GIT_AUTHOR_EMAIL= EMAIL
	export GIT_AUTHOR_NAME="$NAME"
	export GIT_AUTHOR_EMAIL="$EMAIL"
	export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
	export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
}
function git_fake_date() {
	echo "Use the format: 2015-08-20 13:26:15 +0600"
	echo '    Also see git commit --amend --date="Wed Feb 16 14:00 2011 +0100"'
	read -p GIT_AUTHOR_DATE= NEWDATE
	export GIT_AUTHOR_DATE="$NEWDATE"
	export GIT_COMMITTER_DATE="$NEWDATE"
}
function git_fake_reset() {
	unset GIT_AUTHOR_NAME
	unset GIT_AUTHOR_EMAIL
	unset GIT_COMMITTER_NAME
	unset GIT_COMMITTER_EMAIL
	unset GIT_AUTHOR_DATE
	unset GIT_COMMITTER_DATE
}


# =push/pop branch=
# http://www.gnu.org/software/bash/manual/html_node/Directory-Stack-Builtins.html#Directory-Stack-Builtins
function pushb() {
	local new_branch=$1
	local git_dir=$(git rev-parse --git-dir 2> /dev/null)
	if [[ -z "$git_dir" ]]; then
	    echo "You are not in a git repo!"
	    return 1
	fi
	if [[ -z "$new_branch" ]]; then
		echo "You must pass in a branch name"
		return 2
	fi
	local stack_file=$git_dir/.stack.txt
	# read current branch                      current branch   remove *            Get hash if not on branch
	local old_branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' -e 's/(HEAD detached at \([0-9a-f]\+\))/\1/')
	# if we are already on that branch
	if [[ "$old_branch" == "$new_branch" ]]; then
		return 0
	fi
	# move to the new branch
	git checkout $new_branch
	local retval=$?
	if [[ $retval -ne 0 ]]; then
		return $retval
	fi
	# save branch to top of stack
	echo $old_branch >> $stack_file
	# output current stack
	print_branch_stack
}
function popb() {
	local git_dir=$(git rev-parse --git-dir 2> /dev/null)
	if [[ -z "$git_dir" ]]; then
    	echo "You are not in a git repo!"
	    return 1
	fi
	local stack_file=$git_dir/.stack.txt
	if [[ ! -f $stack_file || ! -s $stack_file ]]; then
	    echo "There are no branches to pop!"
	    return 2
	fi
	# get the branch at the top of the stack
	local branch_name=$(tail -n1 $stack_file)
	# move to the branch that was on the top of the stack
	git checkout $branch_name
	local retval=$?
	if [[ $retval -ne 0 ]]; then
		return $retval
	fi
	# remove the top of the stack
	sed -i '$ d' $stack_file
	# output current stack
	print_branch_stack
}
function print_branch_stack() {
	local git_dir=$(git rev-parse --git-dir 2> /dev/null)
	if [[ -z "$git_dir" ]]; then
		echo "You are not in a git repo!"
		return 1
	fi
	local stack_file=$git_dir/.stack.txt
	if [[ ! -f "$stack_file" ]]; then
		# echo "The stack is empty"
		return 0
	fi
	sed ':a;N;$!ba;s/\n/ /g' $stack_file
}
alias branches=print_branch_stack


# =screen=
alias sl='screen -list'
alias sr='screen -r'
function shelp() {
	echo "^a ?      help"
	echo "^a S      horizontal split"
	echo "^a |      verticle split"
	echo "^a <tab>  next region"
	echo "^a c      new window"
	echo "^a n      next window"
	echo "^a p      prev window"
	echo "^a X      Close window"
	echo "^u        Scrolls a half page up"
	echo "^b        Scrolls a page up"
	echo "^d        Scrolls a half page down"
	echo "^f        Scrolls a page down"
}

# =misc=

# process find
##alias pf='ps aux | grep'
#replaced by pgrep
alias pf='echo "use pgrep -f"'

# netstat find
alias nf='netstat -tpna | grep'

# Prevents accidentally overwriting files.
alias mv='mv -i'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'

alias fail='tail -f'

# Shortcuts
alias a='alias -p'
alias e='vim' #edit
alias g='git'
__git_complete g _git
alias h='history'
alias j='jobs -l'
alias p='less' #print
alias t='less +G' # tail
alias v='vim'
# find file name
function f() {
	find . -regex ".*${1}.*"
}
# find inside files
function fi() {
	grep -Hir "$1" .
}
# remove, tail
function frail() {
	if [ -f "$1" ]; then
		rm  $1
	fi
	touch $1
	tail -f $1
}

# Searches git commit messages
function git_message_search() {
	if [ $# -eq 1 ]; then
		git log -1 :/${1}
	else
		git log -${2} :/${1}
	fi
}

# Allows you to paste output from git status to get the list of files
# Most often used when git rm'ing lots of *.orig files (see gr)
function git_params() {
	# string builder
	local sb=''
	while read x; do
		# http://stackoverflow.com/a/12426715
		sb="$sb ${x##* }"
	done
	echo $sb
}
function gitrm() {
	echo "You probably meant git_params()"
}
# Removes files pasted from `git status`
function gr() {
  echo " Try: git clean -i"
}

# =Override PS1==
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
# \e == \033   - escape
# \[\e[X;YYm\] - start style
# \[\e[00m\]   - reset style
# Colors can only be set in this string, not in any other
#Not being in a git directory is causing the "parse_get_branch" to lag which is causing the entrie terminal to lag
#PS1='\[\e[1;31m\]$(exit_code_status)\[\e[00m\]${debian_chroot:+($debian_chroot)}\[\e[01;33m\]$(parse_git_branch_ps2)\[\e[00m\]\[\e[01;34m\]\w\$\[\e[00m\] '
# To set human readable date: date -d @1479417119

# Checks to see if you are SSH'd into a machine
function is_remote_machine() {
	[ -n "$SSH_CLIENT" ]
}
# Checks to see if you are sudo'd as another user
function is_sudoed() {
	[ -n "$SUDO_USER" ]
}

function add_time() {
	PS1=\\D{"%F %T "}$PS1
}
alias add_datetime="add_time"

function parse_git_branch_ps1() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
}
function parse_git_dirty() {
	[[ `git status --porcelain 2> /dev/null` ]] && echo "* "
}
# shows nothing on success, minus with the exit code # on failure
function exit_code_status() {
	local EC=$?
	[[ ${EC} == 0 ]] || echo "X $EC "
}
# hooks
function hook_before_ps1() {
  : #noop
}
function hook_after_ps1() {
  : #noop
}

function hook_terminal_title_ps1(){
  echo '\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]'
}

PROMPT_COMMAND=__prompt_command
function __prompt_command() {
  PS1=$(exit_code_status)
  local Reset='\[\e[00m\]'
  local RedBold='\[\e[1;31m\]'
  local Yellow='\[\e[01;33m\]'
  local WhiteBold='\[\e[02;37m\]'
  local LightBlue='\[\e[01;34m\]'

  PS1="${RedBold}$PS1${Reset}$(hook_before_ps1)${Yellow}$(parse_git_dirty)$(parse_git_branch_ps1)${WhiteBold}$(date +%s) ${Reset}${debian_chroot:+($debian_chroot)}$(hook_after_ps1)${LightBlue}\w\$${Reset} "

  #terminal title
  PS1="$(hook_terminal_title_ps1)$PS1"

  #ssh user@host
  if is_sudoed; then
    PS1="\[\e[1;33m\]\u@\h\[\e[00m\] $PS1"
  fi
}

export EDITOR='vim'

# ==Functions==
function cdg() {
	cd $(git rev-parse --show-toplevel)
}
function md() {
	if [ $# != 1 ]; then
		echo "Usage: md <dir>"
	else
		mkdir -p $1 && cd $1
	fi
}
# displays amount of used RAM and swap
#http://stackoverflow.com/questions/10585978/linux-command-for-percentage-of-memory-that-is-free
function mem() {
        # +/-OS refers to what the Operating System is using for it's own caches (e.g. like disk cache) linuxatemyram.com
        free | grep Mem | awk '{ printf("used(+OS): %.4f%\n", $3/$2 * 100.0) }'
        free | head -n 3 | tail -n 1 | awk '{ printf("used(-OS): %.4f%\n", $3/($3+$4) * 100) }'
}
function swap() {
	free | grep Swap | awk '{ printf("used: %.4f%\n", $3/$2 * 100.0) }'
}
function swap-processes() {
  {
    for file in /proc/*/status; do
      awk '/^Pid|Name|VmSwap/{printf $2 " " $3}END{print ""}' $file;
    done | sort -k 3 -n
    echo "COMMAND PID SIZE kB"
  } | column -t
}
function what() {
	if [ $# == 3 ] && [ $1 == 'is' ] && [ $2 == 'my' ] && [ $3 == 'ip' ]; then
		ifconfig | sed -e '/^\(em1\| *[UTRcI]\)/d'
	elif [ $# == 4 ] && [ $1 == 'is' ] && [ $2 == 'my' ] && [ $3 == 'external' ] && [ $4 == 'ip' ]; then
		curl icanhazip.com
	elif [ $# == 3 ] && [ $1 == 'is' ] && [ $2 == 'my' ] && [ $3 == 'name' ]; then
		hostname
	else
		return 127
	fi
}
function compress-encrypt() {
	if [[ -a $1 ]]; then
		tar -czv $1 | gpg -c > $1.tar.gz.gpg
	fi
}
function decrypt-decompress() {
	if [[ -a $1 ]]; then
		gpg -o - $1 | tar -xz
	fi
}
function beer() {
	if [ "$(id -u)" != "0" ]; then
		echo "Sorry, you are not root."
		return 1
	fi
	echo -e " =\n/ \\\\\n) (\n[_]\nroot beer, get it?\n"
}
function group_by() {
	awk -F_ '{A[$1$2]++}END{for (i in A) print i,A[i]}'
}
# Can just use <command> && exit
function 0exit() {
  if [[ "$?" -eq "0" ]]; then
    exit
  else
    alert "Not exiting: $?"
  fi;
}
function alertfail() {
  if [[ "$?" -ne "0" ]]; then
    alert "Failed: $?"
  fi;
}

# Prints the command that started the given process id
function cmdline() {
  cat /proc/$1/cmdline | strings -1 | less -X -F
}

function countdown() {
  secs=$1
  while [ $secs -gt 0 ]; do
     echo -ne "$secs\033[0K\r"
     sleep 1
     : $((secs--))
  done
}

function countdown2() {
  remaining_secs=$1
  current_secs=$(date +%s)
  trigger_secs=$(expr $remaining_secs + $current_secs - 1)
  while [ $remaining_secs -gt 0 ]; do
    echo -ne "$remaining_secs\033[0K\r"
    sleep 1
    remaining_secs=$(expr $trigger_secs - $current_secs)
    current_secs=$(date +%s)
  done
}

function displaytime() {
  SECONDS=$1
  if [[ "$SECONDS" -gt "86400" ]]; then
    echo "Number of seconds is greater than 1 day!"
    return 1
  fi
  date -ud "@$SECONDS" +'%H hours %M minutes %S seconds'
}

function timer() {
secs=$1
  while [ $secs -gt 0 ]; do
     formatted=$(displaytime $secs)
     echo -ne "$formatted\033[0K\r"
     sleep 1
     : $((secs--))
  done
}

# https://github.com/andreafrancia/trash-cli/
if type trash-put &> /dev/null; then
  alias rm='echo "Use trash-put instead! (perma-delete with \rm or /bin/rm)"; false'
fi
