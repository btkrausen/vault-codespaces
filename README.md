### Support My Content Here:

[![Udemy](https://img.shields.io/badge/Udemy-A435F0?style=for-the-badge&logo=Udemy&logoColor=white)](https://btk.me/vb) [![Github Sponsor](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/btkrausen?frequency=one-time&sponsor=btkrausen)

# HashiCorp Vault Labs

[![Bryan Krausen - badge-generator](https://img.shields.io/static/v1?label=btkrausen&message=Profile&color=blue&logo=github)](https://github.com/btkrausen)

Welcome to this HashiCorp Vault lab repo, where you can get hands-on experience with **HashiCorp Vault** using GitHub Codespaces. In this repository, you’ll find a variety of [labs](./labs) that walk you through using HashiCorp Vault in different scenarios.

**Note:** GitHub provides users with 120 core hours for FREE per month. [Check your current consumption of hours here](https://github.com/settings/billing/summary#:~:text=%240.00-,Codespaces,-Included%20quotas%20reset). Additionally, you can [set a limit of spending for Codespaces on your account here](https://github.com/settings/billing/spending_limit#:~:text=Spending%20limit%20alerts-,Codespaces,-Limit%20spending).

## What’s Included

- A **pre-configured** development container that installs and runs Vault in your Codespace.
- Multiple labs, each with its own `README.md` and step-by-step instructions.
- Example files, scripts, and configurations to help you practice Vault’s core features.

### Built with:

<a href="https://www.vaultproject.io/">
  <img alt="vault" src="https://img.shields.io/badge/Vault-FFD814?style=for-the-badge&logo=Vault&logoColor=black" width="80" height="30" /> <a href="https://github.com/features/codespaces">
  <img alt="Codespaces" src="https://img.shields.io/badge/GitHub-%23121011.svg?style=flat-square&logo=Github&logoColor=white" width="100" height="30" />
</a>

## How to Use

1. **Create a Codespace** from this repo (click the button below or go to the “Code” drop-down, select “Codespaces,” and create a new one).
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Labs Overview

Below are a few example labs you can explore. Each link points to a specific lab file or folder within this repository.

## HashiCorp Vault Basics 💻

| **Lab**                   | **Description**                                  |                                                                                                    **Codespace**                                                                                                    |                  **Link**                   |
| ------------------------- | ------------------------------------------------ | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------: |
| **Install Vault**         | Install Vault from Scratch and Start the Service | [Launch](https://github.com/codespaces/new/btkrausen/vault-codespaces?skip_quickstart=true&machine=basicLinux32gb&repo=907851765&ref=main&devcontainer_path=.devcontainer%2Finstall%2Fdevcontainer.json&geo=UsEast) | [Lab](./labs/lab_install_vault_manually.md) |
| **Intro to Vault**        | Learn basic Vault commands.                      |                                                                             [Launch](https://codespaces.new/btkrausen/vault-codespaces)                                                                             |     [Lab](./labs/lab_intro_to_vault.md)     |
| **Using the Vault UI**    | Configure and Manage Vault using the UI          |                                                                             [Launch](https://codespaces.new/btkrausen/vault-codespaces)                                                                             |        [Lab](./labs/lab_vault_ui.md)        |
| **Using the Vault CLI**   | Practice mananaging Vault using the CLI          |                                                                             [Launch](https://codespaces.new/btkrausen/vault-codespaces)|[Lab](./labs/lab_vault_cli.md)  |
| **Initialize and Unseal** | Learn how to initialize and unseal Vault          |   [Launch](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=907851765&skip_quickstart=true&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Frun%2Fdevcontainer.json&geo=UsEast)                                                                                                   |               [Lab](./labs/lab_vault_init_and_unseal.md)               |

## Vault Authentication 🪪

| **Lab**                     | **Description**                                         |                        **Codespace**                        |                  **Link**                   |
| --------------------------- | ------------------------------------------------------- | :---------------------------------------------------------: | :-----------------------------------------: |
| **Vault Tokens**            | Learn the basics of using Vault tokens to authenticate. | [Launch](https://codespaces.new/btkrausen/vault-codespaces) |      [Lab](./labs/lab_vault_tokens.md)      |
| **Vault Response Wrapping** | Use Response Wrapping to protect secrets                | [Launch](https://codespaces.new/btkrausen/vault-codespaces) |   [Lab](./labs/lab_response_wrapping.md)    |
| **AppRole Auth Method**     | Enable, configure, and use the AppRole Auth Method      | [Launch](https://codespaces.new/btkrausen/vault-codespaces) |  [Lab](./labs/lab_approle_auth_method.md)   |
| **Userpass Auth Method**    | Configure the Userpass Auth Method                      | [Launch](https://codespaces.new/btkrausen/vault-codespaces) |  [Lab](./labs/lab_userpass_auth_method.md)  |
| **Kubernetes Auth Method**  | Learn how to enable and configure the k8s auth method   | [Launch](https://codespaces.new/btkrausen/vault-codespaces) | [Lab](./labs/lab_kubernetes_auth_method.md) |

## Vault Secrets Engines 🔑

| **Lab**                      | **Description**                                         |                        **Codespace**                        |                  **Link**                   |
| ---------------------------- | ------------------------------------------------------- | :---------------------------------------------------------: | :-----------------------------------------: |
| **Key/Value Secrets Engine** | Create, read, update, and delete secrets in Vault.      | [Launch](https://codespaces.new/btkrausen/vault-codespaces) |   [Lab](./labs/lab_kv_secrets_engine.md)    |
| **Transit Secrets Engine**   | Learn how to encrypt data using HashiCorp Vault         | [Launch](https://codespaces.new/btkrausen/vault-codespaces) | [Lab](./labs/lab_transit_secrets_engine.md) |
| **PKI Secrets Engine**       | Use Vault as a Certificate Authority and generate certs | [Launch](https://codespaces.new/btkrausen/vault-codespaces) |   [Lab](./labs/lab_pki_secrets_engine.md)   |

## Vault Management and Operations ⛭

| **Lab**                          | **Description**                                |                        **Codespace**                        |                      **Link**                      |
| -------------------------------- | ---------------------------------------------- | :---------------------------------------------------------: | :------------------------------------------------: |
| **Vault Policies**               | Create and assign policies to restrict access. | [Launch](https://codespaces.new/btkrausen/vault-codespaces) |        [Lab](./labs/lab_vault_policies.md)         |
| **Vault Audit Devices**          | Enable and configure an audit device.          | [Launch](https://codespaces.new/btkrausen/vault-codespaces) |         [Lab](./labs/lab_audit_devices.md)         |
| **Integrate Vault w/ Terraform** | Learn how to query Vault when using Terraform  | [Launch](https://codespaces.new/btkrausen/vault-codespaces) | [Lab](./labs/lab_integrate_terraform_and_vault.md) |

---

## Contributing

If you’d like to add more labs or improve these, feel free to fork this repo or open a pull request. Feedback and contributions are always welcome!

---

Enjoy your journey with Vault!
