 
#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#aliases 
alias ls='ls --color=auto'
alias clr='clear; bash'
alias wipehist='rm ~/.bash_history'
alias minineo='neofetch --backend kitty --source /home/jakub/.config/neofetch/archlogo.png --size 150 --colors 0 0 0 12 12 15 --disable title underline resolution shell de wm wm_theme term theme icons cols model'
alias clock='tty-clock -DctC 4'

#theming
PS1='\e[1;34m\w > \e[0m' 
PS2='\e[1;34m\]... > \e[0m'

#Startup Commands
minineo

