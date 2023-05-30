# Installation steps for BIND9
```
sudo apt-get update
sudo apt-get install bind9 bind9utils bind9-doc
```

# Installation steps for CoreDNS

Requirement: A fresh Ubuntu 20.04 machine with iproute2 and golang installed (golang version 1.17 or higher).

Install iproute2 by giving following commands:
```
$sudo apt-get update
$sudo apt-get -y install iproute2
```
Install golang as follows:
1.) Download Go for Linux from here: https://go.dev/doc/install
2.) Remove any previous Go installation and then extract the archive you just downloaded by giving below command:
    ```
    $ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.5.linux-amd64.tar.gz
    ```
3.) Add /usr/local/go/bin to the PATH environment variable. You can do this by adding the following line to your '$HOME/.profile' or '/etc/profile'
    ```
    export PATH=$PATH:/usr/local/go/bin
    ```
4.) Verify the version of Go installed by giving following command
    ```
    go version
    ```
    Make sure your golang version is 1.17 or higher
5.) Install CoreDNS by giving following commands:
    ```
    $ git clone https://github.com/coredns/coredns
    $ cd coredns
    $ make
    ```
    This should yield a coredns binary.
6.) Install unbound plugin for coreDNS
    ```
    $sudo apt install libunbound-dev
    ```
7.) Add unbound plugin to coreDNS by following steps as follow:
    a.) Update plugin.cfg file. This file contains the list of plugins along with the link to their github repository. For adding the unbound plugin append the following line to the plugin.cfg file.
        ```
        unbound:github.com/coredns/unbound
        ```
    b.) Next, run the following command to install the plugin. (Note: Make sure to run this command inside the coredns directory)
        ```
        $ go get github.com/coredns/unbound
        ```
    c.) Compile CoreDNS using the following commands:
        ```
        $ go generate 
        $ go build
        ```
        Copy the coredns binary from the coredns folder to /usr/bin and create a directory 'coredns' in 'etc'.
    d.) To check if CoreDNS has the new plugin (unbound) run the following command. It will display the list of plugins present in CoreDNS.
        ```
        $ coredns -plugins 
        ```
### Installation steps for dnslookup

1.) Download dnslookup binaries from https://github.com/ameshkov/dnslookup/releases
2.) Go to downloads and extract the contents of the archive by running the command 
    ```
    sudo tar -xzvf dnslookup-linux-amd64-v1.8.1.tar.gz
    ```
3.) Move the dnslookup binary to 'usr/local/bin/'
4.) Check the dnslookup version with command:
    ```
    dnslookup –version
    ```
5.) To test that the dnslookup has been installed successfully, run the following command:
    ```
    $ dnslookup example.org 94.140.14.14
    ```