# link the matlab plugin's files to their appropriate locations
for dir_name in $(find $HOME/.vim/plugged/vim-*/* -maxdepth 1 -type d -not -path '*/.git'); do 
    if [ ! -d $HOME/.vim/$(basename $dir_name) ]; then
        mkdir $HOME/.vim/$(basename $dir_name)
    fi
    for fname in $(find $dir_name/* -maxdepth 1 -not -iname ".*"); do
        dest="$HOME/.vim/$(basename $dir_name)/$(basename $fname)"
        if [ -f $dest ]; then
            echo "skipping $fname"
            continue
        elif [[ "$dest" == *snippets* ]]; then
            # skip the snippets to avoid duplicates
            echo "skiping $fname"
            continue
        fi
        echo "linking $fname to $dest" 
        ln -s $fname $dest   
    done
done

