# DNS_in_linux-namespaces
Emulating DNS and DoH using CoreDNS

## Topology

![multiauth drawio](https://user-images.githubusercontent.com/36440070/224285274-9ce670fe-cbb4-4a57-b1f4-f737f64816f5.png)

### Emulating DNS using CoreDNS

In DNS folder all the files belonging to each of the namespaces are provided in the folders that are named after the respective namespaces. Place these folders (inside DNS) under the path /etc/netns . For example, /etc/netns/host

Then run the env.sh bash file to setup namespaces and routes as per the topology denoted above.

```
sudo ./env.sh
```

#### Start CoreDNS

Now to test out the DNS setup, run coreDNS on local_ns, root_ns, auth1_ns and auth2_ns namespaces.
```
sudo ip netns exec local_ns coredns -conf /etc/coredns/corefile
sudo ip netns exec root_ns coredns -conf /etc/coredns/corefile
sudo ip netns exec auth1_ns coredns -conf /etc/coredns/corefile
sudo ip netns exec auth2_ns coredns -conf /etc/coredns/corefile
```

#### Testing

Test the DNS setup using the below command

```
sudo ip netns exec host dig ns1.test.tcl
sudo ip netns exec host dig ns1.example.org
```

Similarly you can test for ns2.test.tcl and ns2.example.org.

### Emulating DoH using CoreDNS

In DoH folder all the files belonging to each of the namespaces are provided in the folders that are named after the respective namespaces. Place these folders (inside DoH) under the path /etc/netns . For example, /etc/netns/host.

Generate TLS certificates by creating a self signed for d1.test.tcl and d1.example.org and store the tls1.crt and tls1.key files under local_ns/coredns/ and ca.crt in host folder under /etc/netns. You can also generate TLS certificates from a trusted CA.

Then run the env.sh bash file to setup namespaces and routes as per the topology denoted above.

```
sudo ./env.sh
```

#### Start CoreDNS

Now to test out the DoH setup, run coreDNS on local_ns, root_ns, auth1_ns and auth2_ns namespaces.
```
sudo ip netns exec local_ns coredns -conf /etc/coredns/corefile
sudo ip netns exec root_ns coredns -conf /etc/coredns/corefile
sudo ip netns exec auth1_ns coredns -conf /etc/coredns/corefile
sudo ip netns exec auth2_ns coredns -conf /etc/coredns/corefile
```

#### Testing

Test the DoH setup using the below command

```
sudo ip netns exec host dnslookup ns1.test.tcl https://d1.test.tcl/dns-query
sudo ip netns exec host dnslookup ns1.example.org https://d1.example.org/dns-query
```

Similarly you can test for ns2.test.tcl and ns2.example.org.
