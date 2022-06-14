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

##### Restrt wallet

You can now try to restart the Unigrid wallet to check if this has resolved your issues.

#### OSX

{: .no_toc }

On OSX...

##### Restrt wallet

You can now try to restart the Unigrid wallet to check if this has resolved your issues.

