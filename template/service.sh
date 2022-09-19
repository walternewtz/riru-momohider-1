#!/system/bin/sh

MAGISKTMP="$(magisk --path)" || MAGISKTMP=/sbin

MODDIR="${0%/*}"
TARGETLIST="$MAGISKTMP/momohider"
mkdir -p "$TARGETLIST"
## hidelist for momohider, reload every 3s
{ while true; do
       HIDELIST="
       $([ -f "$MODDIR/config/denylist" ] && ( magisk --sqlite "SELECT process FROM denylist" | sed "s/^process=//g" ) \
	   || magisk --sqlite "SELECT process FROM hidelist" | sed "s/^process=//g")"
       rm -rf "$TARGETLIST/target.tmp"
       rm -rf "$TARGETLIST/target.old"
       mkdir "$TARGETLIST/target.tmp" 
       for process in $HIDELIST; do
          echo -n >"$TARGETLIST/target.tmp/$process"
       done
       mv -fT "$TARGETLIST/target" "$TARGETLIST/target.old"
       mv -fT "$TARGETLIST/target.tmp" "$TARGETLIST/target"
       rm -rf "$TARGETLIST/target.tmp"
       rm -rf "$TARGETLIST/target.old"
       sleep 3 || break
done; } &
. "$MODDIR/props.sh"
