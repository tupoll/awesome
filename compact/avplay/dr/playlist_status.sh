#!/usr/local/bin/zsh
echo "******************************************************************"
cat ~/tmp/playlist1 | cut -c21-100 | sed -e :a -e '$q;N;25,$D;ba'
echo "---------------Сейчас играет--------------------------------------"
cat ~/tmp/avplay/name | cut -c21-100 
echo "------------------------------------------------------------------"
echo "Следующие:"
cat ~/tmp/playlist | cut -c21-100 


