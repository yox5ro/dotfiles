#!/bin/sh

if [ $PWD != $HOME/dotfiles ]; then
	echo "init.sh must be excuted in $HOME/dotfiles dir."
	exit 1
fi

# bash dotfiles
for bash_dotfile in $PWD/bash/.*; do
	if [ -f "$bash_dotfile" ] && [ `basename $bash_dotfile` != ".gitkeep" ]; then
		ln -s $bash_dotfile $HOME/`basename $bash_dotfile`
	fi
done

# nvim
nvim_config_dir=$HOME/.config/nvim
if [ ! -d $nvim_config_dir ];then
	mkdir -p $nvim_config_dir
fi
ln -s $PWD/nvim/init.lua $nvim_config_dir/init.lua

