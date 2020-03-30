## Keys, Secret, Service Account
dcos security org service-accounts keypair cassandra-private-key.pem cassandra-public-key.pem
## Create Service Account (cassandra)
dcos security org service-accounts create -p cassandra-public-key.pem -d "Cassandra Service Account" cassandra
dcos security org service-accounts show cassandra-sa

## Create Secret
dcos security secrets create-sa-secret cassandra-private-key.pem cassandra cassandra/cassandra-secret
dcos security secrets list /

## Assign permissions (based on a service account name of "cassandra")
dcos security org users grant cassandra dcos:mesos:master:task:user:nobody create --description "Allow running a task as linux user nobody"
dcos security org users grant cassandra dcos:mesos:master:framework:role:cassandra-role create --description "Allow registering as a framework of role <service-role> with Mesos master"
dcos security org users grant cassandra dcos:mesos:master:reservation:role:cassandra-role create --description "Allow creating Mesos resource reservations of role <service-role>"
dcos security org users grant cassandra dcos:mesos:master:volume:role:cassandra-role create --description "Allow creating Mesos persistent volumes of role <service-role>"
dcos security org users grant cassandra dcos:mesos:master:reservation:principal:cassandra delete --description "Allow unreserving Mesos resource reservations with principal cassandra"
dcos security org users grant cassandra dcos:mesos:master:volume:principal:cassandra delete --description "Allow deleting Mesos persistent volumes with principal cassandra"

## Options
if [ ! -f "options.json" ]; then
	cat > options.json <<EOF
{
    "service": {
        "service_account": "cassandra",
        "service_account_secret": "cassandra/cassandra-secret",
        "security": {
            "transport_encryption": {
                "enabled": false, 
                "allow_plaintext": false

            }
        }
    }
}
EOF
fi

## Install
dcos package install cassandra --options=options.json --yes


