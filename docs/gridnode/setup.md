---
layout: default
title: How to run a gridnode
parent: Gridnode
---

# How to run a gridnode
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Sending tokens

The first step is sending tokens to your address. A gridnode requires that one [input](https://cointelegraph.com/news/what-are-inputs-and-outputs) in your address has exactly 3000 tokens.

To accomplish this we first need to copy an address that has a 0 balance. Click on the clipboard next to your address that you would like to send tokens to.

![](../../assets/images/gn-address-copy.png)

Next we will send exactly 3000 tokens to this address. From the main `Wallet` screen click on send. Then enter the address you just copied and exactly 3000 tokens. Press send and enter your passphrase if you encrypted your wallet.

![](../../assets/images/gn-send-tokens.png)

## Get transaction hash

After the transaction has processed you will see it appear on your `Wallet` screen. We need to wait a few minutes for the transation to register on the network for the next steps. Enter the `Nodes` screen and press the `Setup` button.

![](../../assets/images/gh-setup-view.png)

On the  `Setup` screen you should see your transaction if it has been confirmed by the network. The green check lets you know this transaction has not been used in another node, while the red ban icon lets you know one is in use already.

![](../../assets/images/gh-output.png)

On this same screen we will also need to generate a key for the gridnode. Click on the `Generate Key` button to create one. This will also add it to your clipboard to you can paste it somewhere for easier access. Otherwise just click on the clipboard when you need it.

![](../../assets/images/gh-generate-key.png)

## Server setup

To follow along this guide you will need either a server running Ubuntu 16+ or you have access to or a VPS (Virtual Private Server). There are many choices when it comes to renting VPS servers. Here are a few we recommend and have been using for years.

 [Contabo](https://contabo.com/){: .btn .btn-blue }
 [OVH](https://www.ovhcloud.com/){: .btn .btn-blue }
 
We recommend a minimum of 2GB per gridnode you will run. Later on the gridnodes will benefit from running on their own machines as they will utilize all of the servers resources and be rewarded accordingly.

## Connect to server

### Windows

For windows you can use `powershell` or in Windows 11 `terminal`. We also recommend `bitvise SSH client` which can be downloaded [here](https://www.bitvise.com/ssh-client). The `bitvise` client also comes with a file explorer that can be handy if you want to transfer files to the server. 

For example: below is the command you would enter in `powershell` or `terminal`. Change `root` to whatever user your VPS assigned as a login and `127.0.0.1` to the servers IP address. After connecting to the server you will be prompted to enter your password.

```
ssh root@55.123.22.1
```

If using Bitvise, please follow this [guide](https://www.bitvise.com/getting-started-connect-first-time) on how to connect to your VPS with `bitvise SSH client`.

### OSX and Linux

In OSX and Linux you can use your terminal to connect to the server with a simple `SSH` command. Below is an example of what you would enter into your terminal to connect to the VPS. Change `root` to whatever user your VPS assigned as a login and `127.0.0.1` to the servers IP address. Once connected you will be prompted for a password.

```bash
ssh root@127.0.0.1
```

## gridnode script

We have created an automated script for installing and setting up your gridnode. This script will download the latest wallet on your server and collect the transaction ID we copied earlier in order to generate a gridnode. Click the icon shown below to copy the script to your clipboard.

![](../../assets/images/gn-copy-script.png)

You can also copy the below code and paste this into your terminal. In `bitvise SSH client` you can use right click to paste into the terminal.

```
bash -ic "$(wget -4qO- -o- raw.githubusercontent.com/unigrid-project/unigrid-installer/main/node_installer.sh)" ; source ~/.bashrc
```

After the script has installed docker and the required files you will see it asking for a txid and output index. This was the transaction ID we copied earlier from the setup screen.

Paste your transaction ID into the terminal and press `ENTER`.

![](../../assets/images/gn-paste-txid.png)

After your txid and output ID are entered the script will prompt you for the key we generated earlier. Paste that in as well and press enter.

You should now see the script pulling the latest docker image for `Unigrid`.

![](../../assets/images/gn-image-download.png)

After setup and a full sync of the blockchain (5-10 minutes), you should now see something like the below with a string at the end starting with `ugd_docker`. This is the string we will need to copy back in our conf file to enable the gridnode.

![](../../assets/images/gn-script-end.png)image.png
The outputs from the script are also placed in a txt file on your server. To open that type `nano ~/gridnodes.txt`. If nano is not installed you can also try `vim ~/gridnodes.txt`.
## Configuration file

Back in the `Unigrid Janus` wallet go to the nodes/setup screen again and click on the `Open Config` button. This will open a text file where you paste the output from the script. 

![](../../assets/images/gn-open-config.png)

Each node entry in here must be a single line otherwise the wallet will not properly parse the file. Any other text entered in here other than the output from the script may cause your wallet to not open properly. After you have saved this file and closed it please restart your wallet.

![](../../assets/images/gn-config.png)

## Starting the node

Once you have restarted your wallet the configuration file will be loaded in and allow you to start the node. Please make sure your wallet is in sync before attempting to start `MISSING` nodes. 

To do so simply go to the `Nodes` screen and press the `start` button. This will attempt to start any missing nodes in the list that are disabled. If your wallet is encrypted you will be prompted to enter your password.

![](../../assets/images/gn-start.png)

## Install another node

If you would like to install another node on the same server and have the extra resources. Simply repeat the steps above and run the installer script again. Happy noding!

## Built in script commands

The installer also comes with some handy utility commands to access your nodes and get more info. Below is a short list of some of these commands.

```
unigrid list
````

Shows a list of all running containers that are installed.

```
unigrid status
```

Shows whether the containers are running and for how long.

```
unigrid debug
```

Returns information about the gridnode start start for all containers.

```
unigrid restart-all
```

Restart all containers.

```
unigrid start-all
```

Start all containers.

```
unigrid get-blocks
```

Returns the block height of each node container.


```
unigrid remove-all
```

Removes all containers you have installed. **Warning this cannot be undone. Only use for full reintalls of all contianers.**

```
unigrid help
```

List of available commands for `unigrid`.

## Single node communication

If you would like to communicate with a single node, use the container name followed by the command. For example: the first container installed will be `ugd_docker_1`.

```
ugd_docker_1 getinfo
```

To restart a single container.

```
docker restart ugd_docker_1
```

To enter the container itself.

```
docker exec -it ugd_docker_1 /bin/bash
```

Get the block count of a single container.

```
ugd_docker_1 getblockcount
```