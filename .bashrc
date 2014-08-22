#==git==
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
alias gsh='git show'
alias gl='git log --graph --abbrev-commit --decorate --date=relative --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'

#==screen==
alias sl='screen -list'
alias sr='screen -r'

#==misc==

# process find
alias pf='ps aux | grep'
# netstat find
alias nf='netstat -tpna | grep'

# Prevents accidentally overwriting files.
alias mv='mv -i'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'

# Shortcuts
alias e='vim' #edit
alias f='find -regex ".*${1}.*"'
alias g='git'
alias h='history'
alias j='jobs -l'
alias p='less' #print
alias t='tail -fn0'
alias v='vim'

#==Override PS1==
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
# \e == \033   - escape
# \[\e[X;YYm\] - start style
# \[\e[00m\]   - reset style
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\[\033[01;34m\]\w\$\[\033[00m\] '
#terminal title
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

function parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
}
function parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
