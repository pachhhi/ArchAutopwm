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
	echo -e "${GREEN}Updating System before to install${RESET}"
	sudo pacman -Syu --noconfirm
	
	echo -e "${GREEN}Downloading: bspwm, polybar, sxhkd, rofi, kitty, feh, picom${RESET}"
	sudo pacman -S --noconfirm bspwm polybar sxhkd rofi kitty feh picom

	#BSPWM
	if [ -d "$HOME/.config/bspwm/" ];then
		#error: directory already exists
		echo -e "${EXIST}: BSPWM"
		echo -e "${DEL}"

		read resbspwm

		#Delete bspwm and paste the new
		if [ "$resbspwm" == "y" ];then
			rm -rf "$HOME/.config/bspwm"
			cp -r $HOME/ArchAutopwm/bspwm $HOME/.config/
			echo -e "${OK}"
		else
			echo -e "${DEL}"
			exit 1
		fi

	else
		cp -r $HOME/ArchAutopwm/bspwm $HOME/.config/
		echo -e "${OK}"
	fi
	
	
	#SXHKD
	if [ -d "$HOME/.config/sxhkd" ]; then	
		echo -e "${EXIST} SXHKD"
		echo -e "${DEL}"

		read ressxhkd

		#Delete sxhkd and paste the new
		if [ $ressxhkd == "y" ]; then
			rm -rf "$HOME/.config/sxhkd"
			cp -r $HOME/ArchAutopwm/sxhkd $HOME/.config/
			echo -e "${OK}"
		else	
			echo -e "${BACKUP}"
			exit 1
		fi
	
	else
		cp -r $HOME/ArchAutopwm/sxhkd $HOME/.config/
		echo -e "${OK}"
	fi

	#KITTY
	if [ -d "$HOME/.config/kitty" ]; then
	
		echo -e "${EXIST} KITTY"
		echo -e "${DEL}"

		read reskitty
		
		#Delete sxhkd and paste the new
		if [ $reskitty == "y" ];then
			rm -rf "$HOME/.config/kitty"
			cp -r $HOME/ArchAutopwm/kitty $HOME/.config/
			echo -e "${OK}"
		else		
			echo -e "${BACKUP}"
		fi
	else
		cp -r $HOME/ArchAutopwm/kitty $HOME/.config/
		echo -e "${OK}"
	fi

	#POLYBAR
	if [ -d "$HOME/.config/polybar" ]; then
		
		echo -e "${EXISTS} POLYBAR"
		echo -e "${DEL}"
		
		read respolybar
		
		if [ $respolybar == "y" ]; then
			rm -rf "$HOME/.config/polybar"
			cp -r $HOME/ArchAutopwm/polybar/ $HOME/.config/
			chmod +x $HOME/.config/polybar/forest/launch.sh

			echo -e "${OK}"
		else
			echo -e "${BACKUP}"
		fi			
	else
		cp -r $HOME/ArchAutopwm/polybar/ $HOME/.config/
		chmod +x $HOME/.config/polybar/forest/launch.sh
		echo -e "${OK}"
	fi

	if [ ! -d $HOME/.config/rofi ]; then
		echo -e "${EXIST}: ROFI"
		echo -e "${DEL}"

		read rofires
		if [ $rofires == "y" ]; then
			rm -rf $HOME/.config/rofi
			cp -r $HOME/ArchAutopwm/rofi $HOME/.config/
			sudo chown -R $(whoami):$(whoami) ~/.config/rofi
			echo -e "${OK}"
		else
			echo -e "${BACKUP}"
		fi
	else
		cp -r $HOME/ArchAutopwm/rofi $HOME/.config/
		sudo chown -R $(whoami):$(whoami) ~/.config/rofi
		echo -e "${OK}"
	fi

	#ZSH
	if ! command -v zsh &> /dev/null; then
		echo -e "${GREEN}Installing ZSH${RESET}"
		sudo pacman -S --noconfirm zsh	
		sudo chsh -s $(which zsh)
		#echo "$SHELL"
	
		echo -e "${GREEN}Installing OhMyZsh${RESET}"
		RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		
		if [ -f $HOME/.zshrc ]; then
			rm -rf $HOME/.zshrc
			cp $HOME/ArchAutopwm/.zshrc $HOME/
		else
			cp $HOME/ArchAutopwm/.zshrc $HOME/
		fi

		rm -rf $HOME/.oh-my-zsh
		cp -r $HOME/ArchAutopwm/.oh-my-zsh $HOME/		

		#POWERLEVEL10K
		echo -e "${GREEN}Installing PowerLevel10k${RESET}"
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
		if [ -f $HOME/.p10k.zsh ]; then
			rm -rf $HOME/.p10k.zsh 
			cp $HOME/ArchAutopwm/.p10k.zsh $HOME/
		
		fi
		
		cp $HOME/ArchAutopwm/.p10k.zsh $HOME/
		sudo chown $(whoami):$(whoami) ~/.p10k.zsh	
		sudo chsh -s $(which zsh)
		echo "$SHELL"
		echo -e "${OK}"
	fi	
	
	#PICOM
	if [ -d "$HOME/.config/picom" ]; then
		echo -e "${EXISTS}"
		echo -e "${DEL}"
		
		read respicom
		if [ $respicom == "y" ]; then
			rm -rf $HOME/.config/picom
			cp -r $HOME/ArchAutopwm/picom $HOME/.config/
			echo -e "${OK}"
		else 
			echo "{$BACKUP}"
		fi
	else
		cp -r $HOME/ArchAutopwm/picom $HOME/.config/
		echo -e "${OK}"
	fi
	
	#REBOOT 
	echo -e "${RED}Do you want reboot? (y/n)${RESET}"
	read resreboot
	
	if [ $resreboot == "y" ]; then
		sudo reboot 
	else
		echo -e "Finished!"
	fi
fi	

#p10k todavia no funciona, cuando se descarga no aparece en $HOME
#ya modifique el config.rasi de rofi, ahora creo que apunta hacia el path correcto. modificarlo en el script de test o hacer un git push
