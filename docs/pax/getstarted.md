---
layout: default
title: Pax Cosmos SDK
nav_order: 4
has_children: true
permalink: /docs/pax
---
![](../../assets/images/pax.png)
# Pax
{: .no_toc }

Documentation on the paxd daemon.
{: .fs-6 .fw-300 }

# What is Pax

`pax` is the name for the governance chain for the Unigrid network.

* `pax`: The Unigrid daemon and command-line interface (CLI). Runs a full-node of the `pax` application.

`pax` is built on the Cosmos SDK using the following modules:

* `x/auth`: Accounts and signatures.
* `x/bank`: Token transfers.
* `x/staking`: Staking logic.
* `x/distribution`: Fee distribution logic.
* `x/slashing`: Slashing logic.
* `x/gov`: Governance logic.
* `x/params`: Handles app-level parameters.

About the Unigrid network: 