This sets up a graylog cluster inside Openshift or Kubernetes. 

To deploy, copy manifests/configmaps.yaml.template to configmaps.yaml and update 
with the external URL you will use to access graylog + the address of your elasticsearch 
instance.

Run gen_secrets.sh to create secrets.yaml. This will output the admin password for graylog.

Then:

```
oc create -f serviceaccounts.yaml
```

On Openshift
```
oc adm policy add-scc-to-user anyuid system:serviceaccount:graylog:graylog
```

Then deploy Graylog

```
oc apply -f manifests/
```


