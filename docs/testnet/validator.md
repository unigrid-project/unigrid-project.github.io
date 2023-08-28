---
layout: default
title: Set up a Validator
parent: Testnet
---

# Set up a Validator
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Joining Unigrid Testnet

## General instructions on how to join the Unigrid testnet

### Current testnet

For details of upgrades on the current testnet, as well as syncing, you can check out the testnets repo. If you get stuck, then please ask on Discord.

- **chain-id**: `unigrid-testnet-1`
- **Current Github version tag**: [cosmos-daemond v0.0.5](https://github.com/unigrid-project/chain-testing/releases/download/v0.0.5/cosmos-daemond)

### Minimum Hardware Requirements

- **16GB RAM**
- **200GB of disk space**
- **2 Cores (modern CPU's)**

> **Note**: These specifications are the minimum recommended. Low spec validators WILL get stuck on difficult to process blocks. The testnets accumulate data as the blockchain continues, so you'll need to expand your storage over time.

### cosmos-daemon Installation

To get up and running with the `cosmos-daemon` binary, download it [here](https://github.com/unigrid-project/chain-testing/releases/download/v0.0.5/cosmos-daemond).

You can also use wget like below and pull the latest version.

```bash
# Get the latest release download URL for cosmos-daemond from the GitHub API
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/unigrid-project/chain-testing/releases/latest | grep "browser_download_url.*cosmos-daemond" | cut -d '"' -f 4)

echo "Downloading: $DOWNLOAD_URL"
# Use wget to download the binary
wget $DOWNLOAD_URL

```

### Make the Binary Executable:
After downloading, you need to give the binary execute permissions:
```bash
chmod +x cosmos-daemond

```

### Move the Binary to /usr/local/bin:
To make the binary globally accessible, move it to /usr/local/bin. You'll need sudo permissions for this: 

_You can always store this in any location you like update the location when creating the service._
```bash
sudo mv cosmos-daemond /usr/local/bin/
```
### Configuration of Shell Variables

For this guide, we will be using shell variables. Set them explicitly in your shell .profile, as you did for the Go environment variables.

```bash
# Set the CHAIN_ID
CHAIN_ID=unigrid-testnet-1

# Set your moniker name
MONIKER_NAME="<moniker-name>"

# Example
MONIKER_NAME="HAL 9000"
```


### Setting up the Node

#### Initialize the chain


```bash
cosmos-daemon init $MONIKER_NAME --chain-id $CHAIN_ID
```

### Download the genesis file

```bash
curl https://raw.githubusercontent.com/unigrid-project/chain-testing/master/genesis.json > ~/.$CHAIN_ID/config/genesis.json
```


#### Create a local key pair

```bash
# Create new keypair
cosmos-daemon keys add <key-name>

# Restore existing wallet with mnemonic seed phrase.
cosmos-daemon keys add <key-name> --recover

# Query the keystore for your public address
cosmos-daemon keys show <key-name> -a
```

### Obtain testnet tokens
After obtaining your address, head over to the [Unigrid Discord](https://discord.gg/JDAYCJ9tEb). Request access to the `#testnet-faucet` channel. Inside, you can interact with the bot using the following command.

```
/faucet <address>
```

# Setting up Cosmos Daemon as a Service

1. **Create a Service File**:
   Use your preferred text editor (e.g., `nano`) to create a service file for `cosmos-daemond`:

   ```bash
   sudo nano /etc/systemd/system/cosmos-daemond.service
   ```

   Add the following content to the file:

   ```
   [Unit]
   Description=Cosmos Daemon Service
   After=network.target

   [Service]
   User=unigrid
   ExecStart=/usr/local/bin/cosmos-daemond start --home=/home/unigrid/.unigrid-testnet-1 --p2p.seeds "e5e85ef8eaa493c566108823519bd2c89b3a7803@194.233.95.48:26656,666d2cc217a5aef8b6b7fc8608706df76640b42a@38.242.156.2:26656"
   Restart=always
   RestartSec=3
   StandardOutput=file:/home/<user>/.<CHAIN_ID>/cosmos-daemond.log
   StandardError=file:/home/<user>/.<CHAIN_ID>/cosmos-daemond-error.log

   [Install]
   WantedBy=multi-user.target
   ```

   Replace `<user>` and `<CHAIN_ID>` with appropriate values.

2. **Manage the Service**:

   - **Reload Systemd**:
     After creating or modifying a service file, reload the systemd manager configuration:

     ```bash
     sudo systemctl daemon-reload
     ```

   - **Start the Service**:
     Use the following command to start the `cosmos-daemond` service:

     ```bash
     sudo systemctl start cosmos-daemond.service
     ```

   - **Stop the Service**:
     If you need to stop the service, use:

     ```bash
     sudo systemctl stop cosmos-daemond.service
     ```

   - **Check Service Status**:
     To check the status of the service:

     ```bash
     sudo systemctl status cosmos-daemond.service
     ```

   - **Restart the Service**:
     If you need to restart the service:

     ```bash
     sudo systemctl restart cosmos-daemond.service
     ```

Remember to monitor the logs and the service status regularly to ensure smooth operation.

## Start the node and sync
 
```bash
 sudo systemctl start cosmos-daemond.service
```
To monitor the syncing process you can tail the log file like this.
```bash
tail -f /home/$USER/.CHAIN_ID/cosmos-daemond.log
```

### Upgrade to a validator

#### Obtain Validator Keys:
Run the following command to get the validator keys:
```bash
cosmos-daemond tendermint show-validator --home=/home/$USER/.$CHAIN_ID
```

```bash
cosmos-daemon tx staking create-validator \
 --amount 100000000ugd \
 --commission-max-change-rate "0.1" \
 --commission-max-rate "0.20" \
 --commission-rate "0.1" \
 --min-self-delegation "1" \
--details "Validators don't just validate; they also drop epic bios!" \
 --pubkey=$(cosmos-daemond tendermint show-validator --home=/home/$USER/.$CHAIN_ID) \
 --moniker $MONIKER_NAME \
 --chain-id $CHAIN_ID \
 --gas-prices 0.025ugd \
 --from <key-name>
```

### Backup critical files

Backup the following files located in `~/.$CHAIN_ID/config/`:

- `priv_validator_key.json`
- `node_key.json`

> **Recommendation**: Encrypt the backup of these files.

# Check your Validator

You can use this command to check if your validator is registered.
```bash
cosmos-daemond query tendermint-validator-set | grep -A 4 "<YOUR_VALIDATOR_CONSENSUS_ADDRESS>"
```
For example:
```bash
cosmos-daemond query tendermint-validator-set | grep -A 4 "unigridvalcons1r6yxnhqh4xl2ckdfxlc2d4lt9nlphkjzzzq08w"
- address: unigridvalcons1r6yxnhqh4xl2ckdfxlc2d4lt9nlphkjzzzq08w
  proposer_priority: "242500"
  pub_key:
    type: tendermint/PubKeyEd25519
    value: ZB6Oyiz0AZ9JnyOhOPZEoJoXRKvZdwhInaJbSvzGBYs=
```

# Monitoring a Cosmos SDK Validator

## 1. Setting up Prometheus for Monitoring

[Prometheus](https://prometheus.io/docs/introduction/overview/) is a powerful time-series database used for monitoring.

### Installation:

1. **Set Up a Prometheus Server**: Begin by setting up a dedicated server for Prometheus. Ensure it's separate from your validator to avoid resource competition.

2. **Install Prometheus**: Follow the [official installation guide](https://prometheus.io/docs/prometheus/latest/getting_started/) to get Prometheus up and running.

### Configuration:

1. **Edit Configuration**: Modify the `prometheus.yml` file to specify which nodes to scrape data from. For a Cosmos SDK node, you'd typically scrape data from the node's Prometheus endpoint, usually on port `26660`.

2. **Restart Prometheus**: After making changes, restart the Prometheus service to apply them:
```bash
sudo systemctl restart prometheus
```


## 2. Setting up Grafana for Visualization

[Grafana](https://grafana.com/) allows you to visualize the data that Prometheus collects.

### Installation:

1. **Install Grafana**: Follow the [official installation guide](https://grafana.com/docs/grafana/latest/installation/) to set up Grafana.

### Configuration:

1. **Connect Grafana to Prometheus**: In Grafana, add Prometheus as a data source. This allows Grafana to pull in the data that Prometheus collects.

2. **Import a Dashboard**: There are pre-made Grafana dashboards for Cosmos SDK nodes. Import one of these dashboards for a visual representation of your node's metrics. You can find some on the [Grafana dashboard directory](https://grafana.com/grafana/dashboards).

## 3. Monitoring Your Validator

### Key Steps:

1. **Check Node Status**: Regularly check the status of your validator node to ensure it's operational and syncing with the network.

2. **Monitor Validator Performance**: Use Grafana to monitor key performance metrics of your validator, such as block height, voting power, missed blocks, and more.

3. **Set Up Alerts**: Grafana supports alerting. Set up alerts for critical metrics to be notified if something goes wrong.

4. **Regularly Update & Backup**: Ensure your node software is regularly updated. Also, take regular backups of your validator's keys and configuration.

### Commands for Monitoring:

- **Check Grafana Status**: 
  ```bash
  sudo systemctl status grafana-server
  ```

- **View Prometheus Metrics in a Browser**: Navigate to `http://your_node_ip:26660/metrics` to view the raw metrics that Prometheus is scraping from your Cosmos SDK node.

Remember, monitoring is crucial for validators. It helps ensure the validator is operational, secure, and performing optimally. Regularly check your monitoring tools and respond promptly to any alerts or issues.

## Commands for Monitoring



