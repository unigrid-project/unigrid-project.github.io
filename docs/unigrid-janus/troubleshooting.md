---
layout: default
title: Troubleshooting
parent: Unigrid Janus Wallet
nav_order: 6
---

## Troubleshooting Common Problems
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Wallet stuck on startup screen

If your wallet has been stuck on the startup screen for a long period and does not appear to start. This can happen for a few different reasons.

1.  Your old wallet is still running not allowing the new wallet to start.
2.  Corrupted blockchain data.
3.  Backend not starting properly.

If your old wallet was still running you will need to close that before starting the new Unigrid Janus wallet. If you have the Unigrid Janus wallet running you need to make sure all processes are stopped first.

#### Windows

{: .no_toc }

On Windows press `CTRL + ALT + DEL` and select task manager. In most cases Unigrid will appear at the top of the list there.

![](../../assets/images/task-manager.png)

If you had closed the wallet using a right click you may only see the unigridd.

![](../../assets/images/only-unigridd.png)

Stopping these services can be performed by right clicking them then selecting `End task`.

![](../../assets/images/end-task.png)

##### Restart wallet

You can now try to restart the Unigrid wallet to check if this has resolved your issues.

##### Unpacking Hedgehog

For some Windows users, there might be an issue with unpacking Hedgehog, which is required to run Janus. There are a few reasons this can happen:

Please be sure you have stopped Janus first before proceeding. [Stop Janus](#windows)

1. Antivirus
Antivirus software may block Hedgehog from unpacking, mistakenly identifying it as malware (which it obviously is not). To resolve this issue, try the following steps:

Temporarily disable your antivirus software while starting Janus.
Check if Hedgehog has been quarantined by your antivirus software, and restore it if necessary.
2. Firewall
In some cases, the firewall may block Unigrid. To fix this issue, please check your firewall settings and add Hedgehog as an exception.

3. User Permissions
When Janus starts, it might not have the proper permissions to access your user directory in AppData to unpack Hedgehog. If this is the case, follow the steps below to navigate to the UNIGRID directory and attempt to manually unpack Hedgehog. We're working on resolving this issue in future Janus releases.

In Windows, you can access the AppData folder using the search tool or the Run command. Follow the steps below to open the AppData folder:


Using the Search Tool
Click on the magnifying glass icon in the taskbar to open the search tool.
Type %appdata% in the search box and press Enter.

![](../../assets/images/appdata.png)

Using the Run Command
Alternatively, you can use the Run command to open the AppData folder:

Click on the magnifying glass icon in the taskbar to open the search tool.
Type run in the search box and press Enter. This will open the Run dialog box.
Enter %appdata% in the Run dialog box and click OK.

![](../../assets/images/run.png)

Once the `AppData` folder is open, navigate to the `UNIGRID` folder to access the blockchain data folder. Please note that this is also where your `wallet.dat` file is stored.

![](../../assets/images/ugd-folder.png)

Open the `dependencies` directory, then navigate into the `lib` directory. Scroll down until you see `hedgehog`, then right-click on it and select `Run as administrator`.

![](../../assets/images/hedgehog-open.png)

A terminal window should open and close. After this process is completed, please try to open Janus again.

If you are still experiencing issues, please create a new issue here. 

[Report Issue](https://github.com/unigrid-project/janus-java/issues){: .btn .btn-blue }


##### Force download blockchain

If restarting the wallet did not resolve your issues you can force the wallet to re-download the blockchain data. This will take roughly 7-10 minutes depending on network speed to complete.

In Windows you can click on the magnifier tool and use the search tool to open the AppData folder. Once clicked enter `%appdata%` and press `ENTER`

![](../../assets/images/appdata.png)

In some cases you may need to use the `run` tool on Windows. Instead of searching for `%appdata%` search for `run` then press `ENTER`. This will open the run App where you can then enter `%appdata%` and click `OK`.

![](../../assets/images/run.png)

From here you can open the `UNIGRID` folder to access the blockchain data folder. **Note this is also where your wallet.dat is stored.**

![](../../assets/images/ugd-folder.png)

**Before removing anything in this folder be sure to have stopped your wallet.**

_You should also backup your wallet.dat into another location at this time. This is where all of your addresses and tokens are stored._

![](../../assets/images/wallet-dat.png)

Next select all of these folders and delete them.

blocks, chainstate, zerocoin, database, and sporks

![](../../assets/images/ugd-folder-contents.png)

After removing these folders and restarting your wallet it will attempt a clean download of the blockchain data.

![](../../assets/images/blockchain-download.png)

_If after fully starting you do not see the correct addresses or balance if you have one. It's possible when the wallet restarts it will create a new wallet.dat and backup the old one. If this does happen, just close the wallet after a successful start and replace the wallet.dat in the UNIGRID folder with the correct one and restart._

#### OSX

{: .no_toc }

On OSX...

##### Restart wallet

The Unigrid wallet runs two processes, `Unigrid` and `unigridd`. To be sure both of these are closed you can use your computers `Activity Monitor`.

To access this go into `Applications/Utilities` and there you will find the `Activity Monitor`.

![](../../assets/images/osx-activity.png)

You should then see both `Unigrid` and `unigridd` processes.

![](../../assets/images/osx-process.png)

After this has openend you will need to double click and `quit` both `Unigrid` and `unigridd`.

![](../../assets/images/quit-unigridd.png)

You can now try to restart the Unigrid wallet to check if this has resolved your issues.

##### Force download blockchain

If restarting the wallet did not resolve your issues you can force the wallet to re-download the blockchain data. This will take roughly 7-10 minutes depending on network speed to complete.

In OSX the blockchain data folder is stored in your computers `Application Support` directory. This can be found in this location `<mac HD>/Users/<username>/Library/Application Support/UNIGRID` replacing `<mac HD>` with the name of your hard drive and `<username>` with your username.

Next select all of these folders and delete them inside `UNIGRID`. 

blocks, chainstate, zerocoin, database, and sporks

![](../../assets/images/mac-folders.png)

After removing these folders and restarting your wallet it will attempt a clean download of the blockchain data.

![](../../assets/images/blockchain-download.png)

_If after fully starting you do not see the correct addresses or balance if you have one. It's possible when the wallet restarts it will create a new wallet.dat and backup the old one. If this does happen, just close the wallet after a successful start and replace the wallet.dat in the UNIGRID folder with the correct one and restart._

## Wallet started but blocks are stuck

In the new Unigrid Janus wallet you can check what block your wallet is on by mousing over the blocks icon in the lower left.

![](../../assets/images/block-count.png)

Next you can compare this block height with what the current block on the explorer.  

[Explorer](https://explorer.unigrid.org/){: .btn .btn-blue }

If you find that your block count is lower and your wallet is **NOT** progressing please follow these steps.

[Windows](#force-download-blockchain){: .btn .btn-blue } [OSX](#force-download-blockchain-1){: .btn .btn-blue }

## Windows entry point not found

If you receive an entry point not found error on older Windows 7 or 10 machines.  

![](../../assets/images/entry-point.png)

[FIX](https://appuals.com/how-to-fix-the-procedure-entry-point-ucrtbase-terminate-is-missing-or-could-not-be-located/)



