# Automated LAMP Stack Deployment with Ansible

This repository contains Ansible playbooks and scripts to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack and a Laravel PHP application on two Ubuntu-based servers using Vagrant.

## Requirements

- Vagrant
- Ansible

## Getting Started

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/laravel/laravel.git
    ```

2. Navigate to the cloned repository:

    ```bash
    cd laravel
    ```

3. Update the `hosts` file to specify the IP addresses of your Master and Slave nodes.

4. Update the `deploy_lamp.sh` script to customize the LAMP stack configuration and Laravel application deployment as needed.

5. Run the Ansible playbook to deploy the LAMP stack and Laravel application:

    ```bash
    ansible-playbook --ask-become-pass deploy_lamp.yml
    ```

6. Verify the deployment by accessing the Laravel application URL in your web browser.

## File Structure

- `deploy_lamp.sh`: Bash script to automate the deployment of the LAMP stack and clone the Laravel application from GitHub.
- `deploy_lamp.yml`: Ansible playbook to execute the deployment tasks on the Master and Slave nodes.
- `hosts`: Inventory file specifying the IP addresses of the Master and Slave nodes.
- `README.md`: This file.

## Notes

- Ensure that SSH access is enabled between the Master and Slave nodes and that Ansible can connect to them using SSH keys.
- Customize the deployment script and playbook according to your specific requirements and environment.
