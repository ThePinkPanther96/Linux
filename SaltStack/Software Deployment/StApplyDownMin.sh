#!/bin/bash
#a=`salt-run manage.down | awk {'print $2'} | tr '\n' ' '`
state=$1
function state_apply (){
hst=$1
cmd=$2
echo "trying to execute"
echo $2
echo "on $hst"
if [[ $hst = \chnx* ]];then

ip=`echo $hst | cut -dx -f2 | xargs -I % echo 172.31.22.%`
nc -zv -w 5 $ip 22 > /dev/null 2>&1
sts=$?
if [ $sts -ne 1 ]; then
        echo $hst is up
        salt $hst state.apply "$cmd" | tee /srv/salt/logs/$hst.log

else
        echo $hst is down
        sudo -u syncmgr /usr/cad/chn/site/bin/serverSwitchSalt $hst start
        status=$?
        echo $status
        if [ $status -eq 0 ]; then  #checks if serverSwitchSalt returns with error
        /usr/cad/chn/site/bin/waitForXbash5.sh $ip && sleep 10 && salt $hst state.apply "$cmd" | tee /srv/salt/logs/$hst.log
        sudo -u syncmgr /usr/cad/chn/site/bin/serverSwitchSalt $hst stop
        else
        echo "can't start aws instance"

        fi


fi
else
        echo "Not Chnx"
fi
}



b=($(salt-run manage.down | awk {'print $2'}))
for i in "${b[@]}"
 do
   state_apply $i $state ;
done