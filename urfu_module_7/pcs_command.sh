sudo pcs resource create virtual_ip IPaddr2 ip="10.10.200.190" cidr_netmask="24" nic="ens18" meta migration-threshold="0" op monitor  timeout="60s" interval="10s" on-fail="restart" op stop timeout="60s" interval="0s" on-fail="ignore" op start timeout="60s" interval="0s" on-fail="stop"


sudo pcs resource create my-pgsql pgsql pgctl="/usr/lib/postgresql/12/bin/pg_ctl" psql="/usr/lib/postgresql/12/bin/psql" pgdata="/var/lib/postgresql/12/main" rep_mode="sync" node_list="urfu-pwork-userver-1 urfu-pwork-userver-2 urfu-pwork-userver-3" master_ip="10.10.200.190" restart_on_promote="false" check_wal_receiver="true" pgport="5432" primary_conninfo_opt="password=12345" repuser="repl"

sudo pcs resource promotable my-pgsql promoted-max=1 promotenode-max=1 clone-max=3 clone-node-max=1 notify=true

sudo pcs resource group add master-group virtual_ip

sudo pcs constraint colocation add master-group with Master my-pgsql-clone

sudo pcs constraint order promote my-pgsql-clone then start master-group symmetrical=false score=INFINITY

sudo pcs constraint order demote my-pgsql-clone then stop master-group symmetrical=false score=0