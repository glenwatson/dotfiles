#!/bin/bash
# ==alias autocomplete== http://ubuntuforums.org/showthread.php?t=733397
# ==alias==
alias cd..="cd .." # I often make this mistake
# Because sometimes you don't have the time to put this two letters
alias ..='cd ..'
alias ...='cd ../..'
# =git=
alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gc='git commit'
alias gd='git diff'
alias gdw='git diff --color-words'
alias gdc='git diff --cached'
alias gdcw='git diff --cached --color-words'
alias gs='git status'
alias gst='git stash'
alias gstl='git stash list'
alias gsh='git show'
alias gshst='git show stash@{0}' #What is at the top of my stash?
alias glna='git log --graph --abbrev-commit --decorate --date=relative --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)"'
alias gl='glna --all'
alias gla='gl'
alias gls='git ls-files'
alias gdf='git diff-tree --stat -R -B -C'
function gf() {
	git log --oneline --decorate --format=format:"%C(bold blue)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" | grep ${1}
}
function gud() {
	gst
	gco $1
	git pull origin $1
}

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

## process find
##alias pf='ps aux | grep'
#replaced by pgrep
alias pf='echo "use pgrep"'
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
alias h='history'
alias j='jobs -l'
alias p='less' #print
alias t='tail -fn0'
alias v='vim'
function f() {
	find . -regex ".*${1}.*"
}
# remove, tail
function rail() {
	set -e
	rm  $1
	touch $1
	tail -f $1
}

function git_message_search() {
	if [ $# -eq 1 ]; then
		git log -1 :/${1}
	else
		git log -${2} :/${1}
	fi
}

# =Override PS1==
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
# \e == \033   - escape
# \[\e[X;YYm\] - start style
# \[\e[00m\]   - reset style
# Colors can only be set in this string, not in any other
PS1='\[\e[1;31m\]$(exit_code_status)\[\e[00m\]${debian_chroot:+($debian_chroot)}\[\e[01;33m\]$(parse_git_branch)\[\e[00m\]\[\e[01;34m\]\w\$\[\e[00m\] '
#terminal title
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

# ==Functions==
function parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
}
function parse_git_dirty() {
	[[ `git status --porcelain 2> /dev/null` ]] && echo "*"
}
# shows nothing on success, minus with the exit code # on failure
function exit_code_status() {
	EC=$?
	[[ ${EC} == 0 ]] || echo "X $EC "
}

function md() {
	if [ $# != 1 ]; then
		echo "Usage: md <dir>"
	else
		mkdir -p $1 && cd $1
	fi
}
function what() {
	if [ $# == 3 ] && [ $1 == 'is' ] && [ $2 == 'my' ] && [ $3 == 'ip' ]; then
		ifconfig eth0 | sed -e '/^\(eth0\| *[UTRcI]\)/d'
	elif [ $# == 4 ] && [ $1 == 'is' ] && [ $2 == 'my' ] && [ $3 == 'external' ] && [ $4 == 'ip' ]; then
		curl icanhazip.com
	elif [ $# == 3 ] && [ $1 == 'is' ] && [ $2 == 'my' ] && [ $3 == 'name' ]; then
		hostname
	else
		return 127
	fi
}
