# UBIChain

A decentralized, blockchain-powered Universal Basic Income platform designed to provide transparent, fair, and verifiable income distribution to communities — all on-chain.

---

## Overview

UBIChain consists of ten core Clarity smart contracts that work together to create an autonomous, community-driven UBI ecosystem:

1. **Identity & Onboarding Contract** – Handles user registration and proof-of-personhood.
2. **UBI Treasury Contract** – Stores and manages the global UBI fund.
3. **UBI Claim Contract** – Facilitates regular claims and liveness checks.
4. **Governance DAO Contract** – Allows community voting on protocol rules and upgrades.
5. **Staking & Rewards Contract** – Enables users to stake and earn governance influence.
6. **Donor Pool Contract** – Accepts public/NGO donations with full transparency.
7. **Reputation Contract** – Tracks user activity and contribution metrics.
8. **Fraud Reporting Contract** – Community-led fraud detection and resolution.
9. **Migration Contract** – Enables identity migration and regional transfers.
10. **Interoperability Contract** – Bridges external identity/data sources and chains.

---

## Features

- **Verifiable on-chain identity** with proof-of-personhood  
- **Transparent UBI treasury** with traceable inflows/outflows  
- **Periodic income claiming** with anti-sybil checks  
- **DAO governance** for fair policy control  
- **Stake-based influence** with token rewards  
- **Open donation pool** for NGOs, DAOs, and individuals  
- **Reputation scoring** based on engagement  
- **Fraud detection system** with challenge-based arbitration  
- **Cross-region identity migration**  
- **External data bridge** to support interoperability  

---

## Smart Contracts

### Identity & Onboarding Contract
- Register users via trusted proof mechanisms (e.g., BrightID, World ID)
- Enforces one-person-one-account via sybil resistance
- Assigns a unique UBI identity NFT per user

### UBI Treasury Contract
- Receives and stores UBI funds (in STX or stablecoins)
- Defines budget for claim periods
- Only callable by Claim Contract for disbursements

### UBI Claim Contract
- Allows eligible users to claim UBI periodically
- Verifies liveness and active participation
- Implements cooldowns and claim windows

### Governance DAO Contract
- Token-based or quadratic voting system
- Community proposals on claim size, duration, eligibility
- On-chain execution of passed proposals

### Staking & Rewards Contract
- Lock tokens to gain voting power
- Earn rewards based on staked amount and duration
- Optional delegation support

### Donor Pool Contract
- Accepts public and institutional donations
- Displays transparent contribution history
- Option for donor-directed allocations (e.g., region-based)

### Reputation Contract
- Scores users based on activity (e.g., claiming frequency, community votes)
- Boosts future claim eligibility
- Penalizes fraud or inactivity

### Fraud Reporting Contract
- Users can challenge suspicious accounts
- Arbitrated by DAO vote or reputation-weighted jury
- Enforces slashing or suspension penalties

### Migration Contract
- Allows users to migrate across supported regions
- Retains user reputation and balances
- Prevents duplicate identity creation

### Interoperability Contract
- Verifies off-chain data (e.g., via Oracles or DIDs)
- Enables multi-chain identity and asset bridges
- Supports NGO-backed ID attestations

---

## Installation

1. Install [Clarinet CLI](https://docs.hiro.so/clarinet/getting-started)
2. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ubichain.git
   cd ubichain
   ```
3. Run tests:
    ```bash
    npm test
    ```
4. Deploy contracts to a local or testnet environment:
    ```bash
    clarinet deploy
    ```

---

## Usage

Each smart contract in UBIChain is modular and can function independently, but they are optimized to work together for a seamless universal income experience. Refer to the /contracts folder for Clarity code and comments for each module.

You can use Clarinet console to simulate contract calls and test logic end-to-end.

---

## License

MIT License