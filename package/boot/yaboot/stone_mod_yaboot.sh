# --- T2-COPYRIGHT-NOTE-BEGIN ---
# T2 SDE: package/*/yaboot/stone_mod_yaboot.sh
# Copyright (C) 2004 - 2025 The T2 SDE Project
# Copyright (C) 1998 - 2003 ROCK Linux Project
# 
# This Copyright note is generated by scripts/Create-CopyPatch,
# more information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2.
# --- T2-COPYRIGHT-NOTE-END ---
#
# [MAIN] 70 yaboot Yaboot Boot Loader Setup
# [SETUP] 90 yaboot

create_kernel_list() {
	local first=1
	for x in `(cd /boot/ ; ls vmlinux-*) | sort -Vr`; do
		if [ $first = 1 ]; then
			label=linux first=0
		else
			label=linux-${x/vmlinux-/}
		fi
		ver=${x/vmlinux-}
		cat << EOT

image=$bootpath/$x
	label=$label
	root=$rootdev
	initrd=$bootpath/initrd-${ver}
	read-only
EOT
	done
}

create_yaboot_conf() {
	cat << EOT > /etc/yaboot.conf

# /etc/yaboot.conf created with the T2 SDE Yaboot STONE module

# The bootstrap partition
boot=$bootstrapdev

device=hd:

# The partition with the yaboot binaries
partition=$yabootpart

# Initial multi-boot menu delay
delay=5

# Second yaboot image chooser delay
timeout=80

install=$yabootpath/lib/yaboot/yaboot
magicboot=$yabootpath/lib/yaboot/ofboot

#fgcolor=black
#bgcolor=green

enablecdboot
enablenetboot
enableofboot
EOT

	[ "$macosxpart" ] && \
	  echo -e "\nmacosx=$macosxdev\n" \
	    >> /etc/yaboot.conf

	create_kernel_list >> /etc/yaboot.conf

	gui_message "This is the new /etc/yaboot.conf file:

$( cat /etc/yaboot.conf )"
}

yaboot_install()
{
	# format the boostrap if not already done
	if hmount $bootstrapdev > /dev/null; then
		humount
	else
		if gui_yesno "The boostrap device \
$bootstrapdev is not yet HFS formated. \
Format now?"; then
			hformat $bootstrapdev
		else
			return 1
		fi
	fi

	yaboot_install_doit
}

yaboot_install_doit() {
	gui_cmd 'Installing Yaboot' "echo 'calling ybin' ; ybin"
}

device4() {
	local dev="`sed -n "s,\([^ ]*\) $1 .*,\1,p" /proc/mounts | tail -n 1`"
	if [ ! "$dev" ]; then # try the higher dentry
		local try="`dirname $1`"
		dev="`grep \" $try \" /proc/mounts | tail -n 1 | \
		      cut -d ' ' -f 1`"
	fi
	if [ -h "$dev" ]; then
	  echo "/dev/`readlink $dev`"
	else
	  echo $dev
	fi
}

realpath() {
	dir="`dirname $1`"
	file="`basename $1`"
	dir="`dirname $dir`/`readlink $dir`"
	dir="`echo $dir | sed 's,[^/]*/\.\./,,g'`"
	echo $dir/$file
}

main() {
	rootdev="`device4 /`"
	dev="${rootdev%%[0-9]*}"
	bootdev="`device4 /boot`"
	yabootdev="`device4 /usr`"

	bootstrappart="`parted $dev print | grep bootstrap | sed  's/ *\([[:digit:]]\+\) .*/\1/'`"
	bootstrapdev="$dev$bootstrappart"

	macosxpart="`parted $dev print | grep "hfs+.*OS X" | head -n 1 | sed 's/ .*//'`"
	[ "$macosxpart" ] && macosxdev="$dev$macosxpart"

	if [ "$rootdev" = "$bootdev" ]
	then bootpath=/boot; else bootpath=""; fi

	if [ "$rootdev" = "$yabootdev" ]
	then yabootpath=/usr; else yabootpath=""; fi
	yabootpart="`echo $yabootdev | sed 's/[^0-9]*//'`"

	if [ ! -f /etc/yaboot.conf ]; then
	  if gui_yesno "Yaboot does not appear to be configured.
Automatically install yaboot now?"; then
	    create_yaboot_conf
	    if ! yaboot_install; then
	      gui_message "There was an error while installing yaboot."
	    fi
	  fi
	fi

	while

	gui_menu yaboot 'Yaboot Boot Loader Setup' \
		"Following settings only for expert use: (default)" ""\
		"Bootstrap Device ...... $bootstrapdev" "" \
		"Yaboot partition:path . $yabootpart:$yabootpath" "" \
		"Root Device ........... $rootdev" "" \
		"Boot Device ........... $bootdev" "" \
		"MacOS X partition ..... $macosxdev" "" \
		'' '' \
		'(Re-)Create default /etc/yaboot.conf' 'create_yaboot_conf' \
		'(Re-)Install the yaboot boot chrp script and binary' 'yaboot_install' \
		'' '' \
		"Edit /etc/yaboot.conf (Config file)" \
			"gui_edit 'Yaboot Configuration' /etc/yaboot.conf"
    do : ; done
}
