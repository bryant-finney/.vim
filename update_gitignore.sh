#!/bin/sh
find "$HOME/.vim" -type l | sed s_$HOME/.vim/__ - | sort - > .gitignore
echo .netrwhist >> .gitignore
