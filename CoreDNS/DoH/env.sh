# Cleanup
sudo ip -all netns delete

# Setup topology
sudo ip netns add host
sudo ip netns add local_ns
sudo ip netns add root_ns
sudo ip netns add auth1_ns
sudo ip netns add auth2_ns

sudo ip link add veth0 type veth peer name veth1
sudo ip link add veth2 type veth peer name veth3
sudo ip link add veth4 type veth peer name veth5
sudo ip link add veth6 type veth peer name veth7

sudo ip link set veth0 netns host
sudo ip link set veth1 netns local_ns
sudo ip link set veth2 netns local_ns
sudo ip link set veth3 netns root_ns
sudo ip link set veth4 netns root_ns
sudo ip link set veth5 netns auth1_ns
sudo ip link set veth6 netns root_ns
sudo ip link set veth7 netns auth2_ns

# Assign IP addresses
sudo ip netns exec host ip addr add 10.0.1.2/24 dev veth0
sudo ip netns exec local_ns ip addr add 10.0.1.3/24 dev veth1
sudo ip netns exec local_ns ip addr add 10.1.1.2/24 dev veth2
sudo ip netns exec root_ns ip addr add 10.1.1.3/24 dev veth3
sudo ip netns exec root_ns ip addr add 10.0.0.2/24 dev veth4
sudo ip netns exec auth1_ns ip addr add 10.0.0.3/24 dev veth5
sudo ip netns exec root_ns ip addr add 10.0.2.2/24 dev veth6
sudo ip netns exec auth2_ns ip addr add 10.0.2.3/24 dev veth7

# Bring the interfaces online
sudo ip netns exec host ip link set dev veth0 up
sudo ip netns exec local_ns ip link set dev veth1 up
sudo ip netns exec local_ns ip link set dev veth2 up
sudo ip netns exec root_ns ip link set dev veth3 up
sudo ip netns exec root_ns ip link set dev veth4 up
sudo ip netns exec root_ns ip link set dev veth6 up
sudo ip netns exec auth1_ns ip link set dev veth5 up
sudo ip netns exec auth2_ns ip link set dev veth7 up

sudo ip netns exec host ip link set dev lo up
sudo ip netns exec local_ns ip link set dev lo up
sudo ip netns exec root_ns ip link set dev lo up
sudo ip netns exec auth1_ns ip link set dev lo up
sudo ip netns exec auth2_ns ip link set dev lo up

# Enable ip forwarding
sudo ip netns exec local_ns sysctl -w net.ipv4.conf.all.forwarding=1
sudo ip netns exec root_ns sysctl -w net.ipv4.conf.all.forwarding=1

# Add routes
sudo ip netns exec host ip route add default via 10.0.1.3
sudo ip netns exec local_ns ip route add default via 10.1.1.3
sudo ip netns exec root_ns ip route add default via 10.1.1.2
sudo ip netns exec auth1_ns ip route add default via 10.0.0.2
sudo ip netns exec auth2_ns ip route add default via 10.0.2.2
