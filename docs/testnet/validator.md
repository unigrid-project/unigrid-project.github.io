---
layout: default
title: Set up a Validator
parent: Testnet
nav_order: 1
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

- **chain-id**: `unigrid-testnet-4`
- \*_Current Github release_: [paxd](https://github.com/unigrid-project/cosmos-daemon/releases)

### Minimum Hardware Requirements

- Quad Core or larger AMD or Intel (amd64) CPU
  - ARM CPUs like the Apple M1 are not supported at this time.
- 64GB RAM (can use swap)
- 1TB NVMe Storage
- 100MBPS bidirectional internet connection

> **Note**: These specifications are the minimum recommended. Low spec validators WILL get stuck on difficult to process blocks. The testnets accumulate data as the blockchain continues, so you'll need to expand your storage over time.

### Unigrid Cosmos SDK Pax Installation

# Auto Setup
The fastest way to get started is to use our automated install and setup script (this can also be run again to reset a node if there are changes).

```bash
wget -4qO i.py raw.githubusercontent.com/unigrid-project/unigrid-cosmos-networks/master/unigrid-testnet-4/scripts/i.py && python3 i.py
```

This script will:

- Download and verify the `genesis.json` file.
- Download and set up the `paxd` binary.
- Set up and start the `paxd` service.

**Note:** The script will tail the `paxd` log file at the end. You can exit the log view by pressing `Ctrl+C` and access it again anytime with the command `tail -f ~/.pax/paxd.log`.

# Manual Setup

To get up and running with the `paxd` binary, download it [here](https://github.com/unigrid-project/cosmos-daemon/releases).

You can also use wget like below and pull the latest version.

```bash
# Get the latest release download URL for paxd from the GitHub API
DOWNLOAD_URL=$(curl -s https://github.com/unigrid-project/cosmos-daemon/releases/latest | grep "browser_download_url.*paxd" | cut -d '"' -f 4)

echo "Downloading: $DOWNLOAD_URL"
# Use wget to download the binary
wget $DOWNLOAD_URL

```

### Make the Binary Executable:

After downloading, you need to give the binary execute permissions:

```bash
chmod +x paxd

```

### Move the Binary to /usr/local/bin:

To make the binary globally accessible, move it to /usr/local/bin. You'll need sudo permissions for this:

_You can always store this in any location you like update the location when creating the service._

```bash
sudo mv paxd /usr/local/bin/
```

### Configuration of Shell Variables

For this guide, we will be using shell variables. Set them explicitly in your shell .profile, as you did for the Go environment variables.

```bash
# Set the CHAIN_ID
CHAIN_ID=unigrid-testnet-4

# Set your moniker name
MONIKER_NAME="<moniker-name>"

# Example
MONIKER_NAME="HAL 9000"
```

### Setting up the Node

#### Initialize the chain

```bash
paxd init $MONIKER_NAME --chain-id $CHAIN_ID
```

### Download the genesis file

```bash
curl https://github.com/unigrid-project/unigrid-cosmos-networks/blob/master/unigrid-testnet-4/genesis/genesis.json > ~/.pax/config/genesis.json
```

#### Create a local key pair

```bash
# Create new keypair
paxd keys add <key-name>

# Restore existing wallet with mnemonic seed phrase.
paxd keys add <key-name> --recover

# Query the keystore for your public address
paxd keys show <key-name> -a
```

### Obtain testnet tokens

If you are interested in running a validator on our testnet and require funds (10000.00000000 ugd), please submit your request through our dedicated [Validator Funding Request Form](https://forms.gle/Ubv2u6T1AWgWkTRS9). This form is specifically designed to facilitate the allocation of the necessary testnet tokens to support your validator operations.

# Setting up Cosmos Daemon as a Service

1. **Create a Service File**:
   Use your preferred text editor (e.g., `nano`) to create a service file for `paxd`:

   ```bash
   sudo nano /etc/systemd/system/paxd.service
   ```

   Add the following content to the file:

   ```
   [Unit]
   Description=Cosmos Daemon Service
   After=network.target

   [Service]
   User=<user>
   ExecStart=/usr/local/bin/paxd start --home=/home/<user>/.pax --hedgehog=https://149.102.147.45:39886 --p2p.seeds "8f278bf57932e1f808aefc7c82aaaf130470e2bd@194.233.95.48:26656,e339ab8163a2774fccbc78ff09ffbf0991adc310@38.242.156.2:26656"
   Restart=always
   Restart=always
   RestartSec=3
   StandardOutput=file:/home/<user>/.pax/paxd.log
   StandardError=file:/home/<user>/.pax/paxd-error.log

   [Install]
   WantedBy=multi-user.target
   ```

   Replace `<user>` with appropriate values.

2. **Manage the Service**:

   - **Reload Systemd**:
     After creating or modifying a service file, reload the systemd manager configuration:

     ```bash
     sudo systemctl daemon-reload
     ```

   - **Start the Service**:
     Use the following command to start the `paxd` service:

     ```bash
     sudo systemctl start paxd.service
     ```

   - **Stop the Service**:
     If you need to stop the service, use:

     ```bash
     sudo systemctl stop paxd.service
     ```

   - **Check Service Status**:
     To check the status of the service:

     ```bash
     sudo systemctl status paxd.service
     ```

   - **Restart the Service**:
     If you need to restart the service:

     ```bash
     sudo systemctl restart paxd.service
     ```

Remember to monitor the logs and the service status regularly to ensure smooth operation.

## Start the node and sync

```bash
 sudo systemctl start paxd.service
```

To monitor the syncing process you can tail the log file like this.

```bash
tail -f /home/$USER/.pax/paxd.log
```

### Upgrade to a validator

#### Obtain Validator Keys:

Run the following command to get the validator keys:

```bash
paxd tendermint show-validator
```

> The required tokens to run a validator on our testnet is 1000000000000 (10,000 tokens) on mainnet it will be a much lower amount.

#### Create a json file for your validator

Get your validator key: 
```bash
paxd tendermint show-validator
```
Example result:
```
{"@type":"/cosmos.crypto.ed25519.PubKey","key":"JHlFY5CXJ/Sh8Be2JRSxxlMYH7Iie92iZX76rN5c75M="}

```
#### Add Avatar (not required)
The `--identity` can be used as to verify identity with systems like Keybase or UPort. When using Keybase, `--identity` should be populated with a 16-digit string that is generated with a [keybase.io](https://keybase.io/) account. It's a cryptographically secure method of verifying your identity across multiple online networks. The Keybase API allows us to retrieve your Keybase avatar. This is how you can add a logo to your validator profile.

Example my-validator.json:
```bash
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"JHlFY5CXJ/Sh8Be2JRSxxlMYH7Iie92iZX76rN5c75M="},
  "amount": "1000000000000ugd",
  "moniker": "Hedgehogs Validator",
  "identity": "<keybase 16-digit string",
  "website": "https://unigrid.org",
  "details": "Validators don't just validate; they also drop epic bios!",
  "commission-rate": "0.1",
  "commission-max-rate": "0.20",
  "commission-max-change-rate": "0.1",
  "min-self-delegation": "1000000000000"
}
```

Start your validator:
```bash
paxd tx staking create-validator path/to/my-validator.json --from <keyname> --chain-id unigrid-testnet-4
```

### Backup critical files

Backup the following files located in `~/.pax/config/`:

- `priv_validator_key.json`
- `node_key.json`

> **Recommendation**: Encrypt the backup of these files.

# Check your Validator

You can use this command to check if your validator is registered.

> This will expect your unigridvalcons address, so if your address is `unigrid1qm7qj5t96yz8xehx6533hfm3m8nd67la29xxwr` you will pass in `unigridvalcons1qm7qj5t96yz8xehx6533hfm3m8nd67la29xxwr`
```bash
paxd query tendermint-validator-set | grep -A 4 "<YOUR_VALIDATOR_CONSENSUS_ADDRESS>"
```

For example:

```bash
paxd query tendermint-validator-set | grep -A 4 "unigridvalcons1qm7qj5t96yz8xehx6533hfm3m8nd67la29xxwr"
```
### Result
```
- address: unigridvalcons1qm7qj5t96yz8xehx6533hfm3m8nd67la29xxwr
  proposer_priority: "0"
  pub_key:
    type: tendermint/PubKeyEd25519
    value: OX65CA4ca/FYrcwz1cRcoSJFeLW940n9FaC9HK25zXc=
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

## Closing

If you run into any issues or have suggestions, please reach out the info@unigrid.org.
