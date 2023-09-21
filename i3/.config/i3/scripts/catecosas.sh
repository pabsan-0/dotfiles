#!/usr/bin/env bash


open_in_terminal () {
    local command="$1"

    if command -v konsole >/dev/null; then
        konsole -e "$1"
    elif command -v terminator >/dev/null; then
        terminator -e "$1"
    elif command -v gnome-terminal >/dev/null; then
        gnome-terminal -- bash -c "$1; read -p 'Press Enter to exit'"
    elif command -v x-terminal-emulator >/dev/null; then
        x-terminal-emulator -e "$1"
    else
        echo "No supported terminal emulators found."
    fi
}

# Options
github='1  GitHub'
gists='2  Gists'
outlook='3  Outlook'
onedrive='4  One Drive'
bitbucket='5  Bitbucket'
sharepoint='6  Sharepoint Upia'
zoho='7  Zoho'
symphony='8  Symphony'
idinet='9  Idinet'
imputador='10  El Imputador'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu -i \
		-p "CATEC launcher" 
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$github\n$gists\n$outlook\n$onedrive\n$bitbucket\n$sharepoint\n$zoho\n$symphony\n$idinet\n$imputador" | rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
	$github)
		xdg-open https://github.com/$(git config user.name)
		;;
	$gists)
		xdg-open https://gist.github.com/$(git config user.name)
		;;
	$outlook)
		xdg-open https://outlook.office.com/mail/
		;;
	$onedrive)
		xdg-open https://fadacatecatlas-my.sharepoint.com/
		;;
	$bitbucket)
		xdg-open https://bitbucket.org/dashboard/overview
		;;
	$sharepoint)
		xdg-open https://fadacatecatlas.sharepoint.com/_layouts/15/sharepoint.aspx?
		;;
	$zoho)
		xdg-open https://projects.zoho.eu/portal/catec
		;;
	$symphony)
		xdg-open http://controlpresencia.catec.aero
		;;
	$idinet)
		xdg-open http://erp.catec.aero/IDiNet/misproyectos.aspx?pag=MisHoras#DiaAnterior
		;;
	$imputador)
                open_in_terminal el_imputador	
		;;
esac

