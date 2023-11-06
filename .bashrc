#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias vim=nvim
alias cat=bat
alias icat="kitty +kitten icat"
alias lg=lazygit

export PATH=$HOME/.local/bin:$PATH

export CMAKE_GENERATOR=Ninja
export CMAKE_BUILD_TYPE=RelWithDebInfo
export CMAKE_CONFIGURATION_TYPES="Debug;Release;MinSizeRel;RelWithDebInfo"
export CMAKE_EXPORT_COMPILE_COMMANDS=TRUE
export CMAKE_COLOR_DIAGNOSTICS=ON
export CTEST_OUTPUT_ON_FAILURE=TRUE

export CONAN_CMAKE_GENERATOR=Ninja
export CONAN_SYSREQUIRES_MODE=verify
export CONAN_SYSREQUIRES_SUDO=True

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}
export PS1='\[\e[\033[01;34m\]\u@\h \[\e[38;5;211m\]\W\[\e[\033[38;5;48m\] $(parse_git_branch)\[\e[\033[00m\]\$ '

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  source $HOME/.nix-profile/etc/profile.d/nix.sh;
fi
