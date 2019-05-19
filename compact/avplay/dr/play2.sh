#!/usr/local/bin/zsh

mkdir -p ~/tmp/avplay/players/
DIR2=~/tmp/avplay/players
cp -R ~/tmp/playlist1 ~/tmp/avplay/playlist
cat ~/tmp/avplay/playlist |sed '1d'|  /usr/bin/awk '{print $0}'>~/tmp/playlist1
head -n 1 ~/tmp/avplay/playlist | tail -n1 >~/tmp/avplay/name

A=$(cat ~/tmp/avplay/name |  /usr/bin/awk '{print $0}')
cp $A $DIR2
avplay -nodisp $DIR2/*.* 
rm -rf $DIR2
rm -rf ~/tmp/avplay/name
cat ~/tmp/avplay/playlist |sed '1,2d'|  /usr/bin/awk '{print $0}'>~/tmp/playlist1
head -n 2 ~/tmp/avplay/playlist | tail -n1 >~/tmp/avplay/name

B=$(cat ~/tmp/avplay/name |  /usr/bin/awk '{print $0}')
cp $B $DIR2
avplay -nodisp $DIR2/*.*  
rm -rf $DIR2
rm -rf ~/tmp/avplay/name
cat ~/tmp/avplay/playlist |sed '1,3d'|  /usr/bin/awk '{print $0}'>~/tmp/playlist1
head -n 3 ~/tmp/avplay/playlist | tail -n1 >~/tmp/avplay/name

C=$(cat ~/tmp/avplay/name |  /usr/bin/awk '{print $0}')
cp  $C $DIR2
avplay -nodisp $DIR2/*.*  
rm -rf $DIR2
rm -rf ~/tmp/avplay/name
~/.config/awesome/compact/avplay/dr/play1.sh
