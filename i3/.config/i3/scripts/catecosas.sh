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

github='github'
gists='gists'
outlook='outlook'
onedrive='onedrive'
bitbucket='bitbucket'
mind='mind'
mind_smartear='mind/smartear_ai'
jira='jira'
indraweb='indraweb'
dedicaciones='indraweb/dedicaciones'
service_point='indraweb/servicepoint'
calendario_laboral='indraweb/calendario'
forticlient='forticlient'
chatgpt='chatgpt'
copilot='github-copilot'
zerotier='zerotier'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu -i \
		-p "CATEC launcher" 
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$github\n$gists\n$outlook\n$onedrive\n$bitbucket\n$mind\n$mind_smartear\n$jira\n$indraweb\n$dedicaciones\n$service_point\n$calendario_laboral\n$forticlient\n$chatgpt\n$copilot\n$zerotier" | rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
	$github)
		xdg-open https://github.com/$(git config user.name)?tab=repositories
		;;
	$gists)
		xdg-open https://gist.github.com/$(git config user.name)
		;;
	$outlook)
		xdg-open https://outlook.office.com/mail/
		;;
	$onedrive)
		xdg-open https://indra365-my.sharepoint.com/my
		;;
	$bitbucket)
		xdg-open https://bitbucket.indra.es
		;;
	$mind)
		# xdg-open https://mind.indra.es/display/ANTEXIA
		xdg-open https://mind.indra.es/display/ANTEXIA/Reuniones+de+seguimiento
		;;
	$mind_smartear)
		# xdg-open https://mind.indra.es/display/ANTEXIA
		xdg-open https://mind.indra.es/pages/viewpage.action?pageId=933661105
		;;
	$jira)
        xdg-open "https://jira.indra.es/secure/RapidBoard.jspa?rapidView=16829&projectKey=ANTEXIA"
		;;
	$indraweb)
		xdg-open https://www.indraweb.net/languages/es-es/Paginas/default.aspx
		;;
	$dedicaciones)
		xdg-open https://apps.indraweb.net/DedicacionesWEB/pages/homeimputacion.xhtml
		;;
    $service_point)
        xdg-open "https://indraistiprovisioning-dwp.onbmc.com/dwp/app/#/catalog"
        ;;
	$calendario_laboral)
		xdg-open https://apps.indraweb.net/calendarios/micalendario.jsp
		;;
	$forticlient)
        forticlient gui
		;;
	$chatgpt)
		xdg-open https://chatgpt.com/
		;;
	$copilot)
		xdg-open https://github.com/copilot
		;;
	$zerotier)
		xdg-open https://my.zerotier.com/
		;;

esac

