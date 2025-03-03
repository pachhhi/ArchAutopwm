#!/bin/bash

RED='\033[31m'
GREEN='\033[32m'
RESET='\033[0m'

OK='\033[32mSuccessfull\033[0m'
DEL="${RED}Do you want delete your actual directory/config and make a new configuration?: (${RESET}${GREEM}Y${RESET}${RED}/N)${RESET}"
BACKUP="${RED}Delete or make a backup and try again${RESET}"
EXIST="${RED}Directory/Config already exists:${RESET}"

#Verify Arch Linux
if ! grep -q "Arch Linux" /etc/os-release;then
	echo -e "${RED}Script only for Arch Linux${RESET}"
	exit 1
else 
	#Update System
	echo "Updating System"
	sudo pacman -Syu --noconfirm
	sudo pacman -S --noconfirm bspwm polybar sxhkd rofi kitty feh picom

	#BSPWM
	if [ -d "$HOME/.config/bspwm/" ];then
		#error: directory already exists
		echo -e "${EXISTS}: BSPWM"
		echo -e "${DEL}"

		read resbspwm

		#Delete bspwm and paste the new
		if [ "$resbspwm" == "y" ];then
			rm -rf "$HOME/.config/bspwm"
			cp -r $HOME/ArchAutopwm/bspwm $HOME/.config/
			echo "${OK}"
		else
			echo -e "${DEL}"
			exit 1
		fi

	else
		cp -r $HOME/ArchAutopwm/bspwm $HOME/.config/
		echo -e "${OK}"
	fi
	
	
	#SXHKD
	if [ -d "$HOME/.config/sxhkd"];then	
		echo -e "${EXIST} SXHKD"
		echo -e "${DEL}"

		read ressxhkd

		#Delete sxhkd and paste the new
		if [ $ressxhkd == "y" ];then
			rmdir -rf "$HOME/.config/sxhkd"
			cp -r $HOME/ArchAutopwm/sxhkd $HOME/.config/
			echo "${OK}"
		else	
			echo -e "${BACKUP}"
			exit 1
		fi
	
	else
		cp -r $HOME/ArchAutopwm/sxhkd $HOME/.config/
		echo -e ${OK}
	fi

	#KITTY
	if [ -d "$HOME/.config/kitty" ];then
	
		echo -e "${EXIST} KITTY"
		echo -e "${DEL}"

		read reskitty
		
		#Delete sxhkd and paste the new
		if [ $reskitty == "y" ];then
			rmdir -rf "$HOME/.config/kitty"
			cp -r $HOME/ArchAutopwm/kitty $HOME/.config/
			echo -e "${OK}"
		else		
			echo -e "${BACKUP}"
			exit 1
	else
		cp -r $HOME/ArchAutopwm/kitty $HOME/.config/
		echo -e "${OK}"
	fi

	#POLYBAR
	if [ -d "$HOME/.config/polybar" ];then
		
		echo -e "${EXISTS} POLYBAR"
		echo -e "${DEL}"
		
		read respolybar
		
		if [ $respolybar == "y" ];then
			rm -rf "$HOME/.config/polybar"
			#Ejecutar launch.sh
			cp -r $HOME/ArchAutopwm/polybar/ $HOME/.config/
			echo -e "${OK}"
		else
			echo -e "${BACKUP}"
		fi			
	else
		cp -r $HOME/ArchAutopwm/polybar/ $HOME/.config/
		chmod +x ~/.config/polybar/forest/launch.sh
		~/.config/polybar/forest/launch.sh
		echo -e "${OK}"
	fi

	#ZSH
	if command -v zsh &> /dev/null; then
		echo "Installing ZSH"
		sudo pacman -S --noconfirm zsh	
		chsh -s $(which zsh)
		echo "$SHELL"
	fi	
	
	#OHMYZSH
	ZSHRC="$HOME/.zshrc"
	if [ ! -f "$ZSHRC" ]; then
		echo "Installing OhMyZsh"
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		rm -rf $HOME/.zshrc
				
		#POWERLEVEL10K
		if [ ! -d "$HOMEHOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
			git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
		fi
		cp ~/ArchAutopwm/.zshrc $HOME/
		echo -e "${OK}"
	else 
		echo -e "${BACKUP}"
	fi

	#PICOM
	if [ -d "$HOME/.config/picom" ]; then
		echo -e "${EXISTS}"
		echo -e "${DEL}"
		
		read respicom
		if [ $respicom == "y" ]; then
			rm -rf $HOME/.config/picom
			cp $HOME/ArchAutopwm/picom $HOME/.config/
			echo "${OK}"
		else 
			echo "{$BACKUP}"
		fi
	else
		cp $HOME/ArchAutopwm/picom $HOME/.config/
		echo "${OK}"
	fi
	
	#REBOOT NOW
	echo -e "${REBOOT}"

	if [ $REBOOT == "y" ]; then
		sudo reboot now 
	else
		echo -e "Finished!"
	fi
fi	

