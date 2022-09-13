#!/usr/bin/env bash
outfile=/tmp/post-configure-out.txt
echo "Executing postconfigure cli" > $outfile
ls -al $JBOSS_HOME >> $outfile
echo '--' >> $outfile
ls -al $JBOSS_HOME/extensions >> $outfile
echo '--' >> $outfile
cat $JBOSS_HOME/extensions/system-properties.cli >> $outfile
$JBOSS_HOME/bin/jboss-cli.sh --connect --file=$JBOSS_HOME/extensions/system-properties.cli &> /tmp/j-out.txt
