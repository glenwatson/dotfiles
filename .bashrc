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
alias glna='git log --graph --abbrev-commit --decorate --date=relative --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an (%cn)%C(reset)%C(bold yellow)%d%C(reset)"'
alias gltime='git log --pretty=format:"%ad (%an) %cd (%cn) %h %s" --graph'
alias gl='glna --all'
alias gla='gl'
alias gls='git ls-files'
alias gdf='git diff-tree --stat -R -B -C'
alias gn='git notes'
alias cdgit='cd $(git rev-parse --show-toplevel)'
function gf() {
	git log --oneline --decorate --all --format=format:"%C(bold blue)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" | grep ${1}
}
function gud() {
	gst
	gco $1
	git pull origin $1
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
# =Override PS1==
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
# \e == \033   - escape
# \[\e[X;YYm\] - start style
# \[\e[00m\]   - reset style
# Colors can only be set in this string, not in any other
PS1='\[\e[1;31m\]$(exit_code_status)\[\e[00m\]${debian_chroot:+($debian_chroot)}\[\e[01;33m\]$(parse_git_branch)\[\e[00m\]\[\e[01;34m\]\w\$\[\e[00m\] '
#terminal title
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#ssh user@host
if is_remote_machine || is_sudoed; then
	PS1="\[\e[1;33m\]\u@\h\[\e[00m\] $PS1"
fi

# ==Functions==
function md() {
	if [ $# != 1 ]; then
		echo "Usage: md <dir>"
	else
		mkdir -p $1 && cd $1
	fi
}
function mem() {
	TOTAL_KB=$(grep MemTotal: /proc/meminfo | cut -d\  -f 8)
	FREE_KB=$(grep MemFree: /proc/meminfo | cut -d\  -f 10)
	USED_KB=$(awk "BEGIN { print $TOTAL_KB - $FREE_KB }")
	awk "BEGIN { print ($USED_KB / $TOTAL_KB) * 100 \"%\"}"
	awk "BEGIN { print $USED_KB / (1024*1024) \"(GB) out of \" $TOTAL_KB / (1024*1024) \"(GB)\" }"
	awk "BEGIN { print $USED_KB / 1024 \"(MB) out of \" $TOTAL_KB / 1024 \"(MB)\" }"
	awk "BEGIN { print $USED_KB \"(KB) out of \" $TOTAL_KB \"(KB)\" }"
}
function swap() {
	TOTAL_KB=$(grep /dev /proc/swaps | cut -f 2)
	USED_KB=$(grep /dev /proc/swaps | cut -f 3)
	awk "BEGIN { print ($USED_KB / $TOTAL_KB) * 100 \"%\"}"
	awk "BEGIN { print $USED_KB / (1024*1024) \"(GB) out of \" $TOTAL_KB / (1024*1024) \"(GB)\" }"
	awk "BEGIN { print $USED_KB / 1024 \"(MB) out of \" $TOTAL_KB / 1024 \"(MB)\" }"
	awk "BEGIN { print $USED_KB \"(KB) out of \" $TOTAL_KB \"(KB)\" }"
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
