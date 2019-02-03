function link_files () {
    dir_name="$1"
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
}

# link black's files
for dir_name in $(find $HOME/.vim/plugged/black/* -maxdepth 1 -type d -not -path '*/.git'); do 
    link_files "$dir_name"
done

# link ultisnips
for dir_name in $(find $HOME/.vim/plugged/ultisnips/* -maxdepth 1 -type d -not -path '*/.git'); do 
    link_files "$dir_name"
done


