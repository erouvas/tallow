#!/usr/bin/env bash
outfile=/tmp/post-configure-out.txt
echo "Executing postconfigure cli" > $outfile
ls -al $JBOSS_HOME >> $outfile
echo '--' >> $outfile
ls -al $JBOSS_HOME/extensions >> $outfile
echo '--' >> $outfile
cat $JBOSS_HOME/extensions/system-properties.cli >> $outfile
$JBOSS_HOME/bin/jboss-cli.sh --connect --file=$JBOSS_HOME/extensions/system-properties.cli &> /tmp/j-out.txt

#
# put kie-server into place
#
pushd $JBOSS_HOME/extensions &> /dev/null
    cd kie-server
    mv kie-server.war "$JBOSS_HOME"/standalone/deployments
    : > "$JBOSS_HOME"/standalone/deployments/kie-server.war.dodeploy
    cp SecurityPolicy/* "$JBOSS_HOME"/bin
popd &> /dev/null

#
# define standard users
#
# configure PAM users
kieServerUserName=administrator
kieControllerUserName=ctrl_administrator
declare -a uList
declare -A uPass
declare -A uRole
u="pamAdmin"               && uList+=( "$u" ) && uPass["$u"]='S3cr3tK3y#' && uRole["$u"]='kie-server,rest-all,admin,analyst,kiemgmt,manager,user,developer,process-admin'
u="pamAnalyst"             && uList+=( "$u" ) && uPass["$u"]='r3dh4t456^' && uRole["$u"]='rest-all,analyst'
u="pamDeveloper"           && uList+=( "$u" ) && uPass["$u"]='r3dh4t456^' && uRole["$u"]='rest-all,developer'
u="pamUser"                && uList+=( "$u" ) && uPass["$u"]='r3dh4t456^' && uRole["$u"]='rest-all,user'
u="$kieServerUserName"     && uList+=( "$u" ) && uPass["$u"]='Inspection1'  && uRole["$u"]='kie-server,rest-all'
u="$kieControllerUserName" && uList+=( "$u" ) && uPass["$u"]='Inspection1' && uRole["$u"]='kie-server,rest-all'

pushd $JBOSS_HOME/extensions &> /dev/null
    for u in "${uList[@]}"; do
        ./add-user.sh -sc "$scPath" -s -a --user "$u" --password "${uPass[$u]}" --role "${uRole[$u]}"
        summary "Added PAM user :- $u / ${uPass[$u]} / ${uRole[$u]}"
    done
popd &> /dev/null
