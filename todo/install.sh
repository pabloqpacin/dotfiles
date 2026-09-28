
# make_backups() {
# 	ITEMS_TO_BACKUP=('~/.config' '.gitconfig')
# 
# 	for ITEM in $ITEMS_TO_BACKUP; do
# 		echo ${ITEM[@]}{,.bak}
# 		# cp ${ITEM[@]}{,.bak}
# 	done
# }

DOTFILES_DIR="~/dotfiles-niri"


if true; then
	mv "~/.config/fish" "~/.config/fish.bak"
	ln -s "${DOTFILES_DIR}/fish" "~/.config"
fi


