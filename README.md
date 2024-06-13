# ansible-dev
Ansible dev environment

## Code of Conduct

[`CODE_OF_CONDUCT.md`][org-coc]:
> The Creative Commons team is committed to fostering a welcoming community.
> This project and all other Creative Commons open source projects are governed
> by our [Code of Conduct][code_of_conduct]. Please report unacceptable
> behavior to [conduct@creativecommons.org](mailto:conduct@creativecommons.org)
> per our [reporting guidelines][reporting_guide].

[org-coc]: https://github.com/creativecommons/.github/blob/main/CODE_OF_CONDUCT.md
[code_of_conduct]: https://opensource.creativecommons.org/community/code-of-conduct/
[reporting_guide]: https://opensource.creativecommons.org/community/code-of-conduct/enforcement/


## Contributing

See [`CONTRIBUTING.md`][org-contrib].

[org-contrib]: https://github.com/creativecommons/.github/blob/main/CONTRIBUTING.md


### Goals

The aim of the project is to establish a robust and localized development environment utilizing Ansible and Docker. This environment will mirror a professional work setting, incorporating a dedicated security server (Bastion), automation through Ansible, a web server, and a data storage server. This configuration will simplify and secure development processes and serve as a blueprint for future projects at CC.


#### Docker containers:

The [`docker-compose.yml`](docker-compose.yml) file defines the following
containers:

- WIP: Bastion (SSH jump server)
- **ansible-dev** - Ansible
- **web-dev** - Web server (Apache2/WordPress)
- **db-dev** - Database server (MariaDB)


![image](https://github.com/creativecommons/ansible-dev/assets/90766122/21baa18d-715e-4908-9620-15c768994011)


See [Create Local Ansible Dev Environment Using Docker](https://opensource.creativecommons.org/programs/project-ideas/#ansible-dev-env) for more details.


### Setup

- Create the `.env` file:
    ```shell
    cp .env.example .env
    ```

- Execute the `generate_ssh_keys` script:
    ```shell
    ./generate_ssh_keys.sh
    ```

- Build and start Docker:
    ```shell
    docker-compose up
    ```

- Wait for the build and initialization to complete


#### SSH (Work in Progress)

The SSH setup has been established and is currently in use for the Ansible container. Follow the steps below to generate and use the SSH keys for the sysadmin user:

- Execute the generate-ssh-keys.sh script to generate the keys used by the sysadmin user:
    ```shell
    ./generate-ssh-keys.sh
    ```

- Bring down the existing Docker containers and start them again:
    ```shell
    docker-compose down
    docker-compose up -d
    ```

- Ensure the Docker containers are running:
    ```shell
    docker ps
    ```

- Execute the following command to confirm that SSH is working fine:
    ```shell
    ssh -i ./sysadmin-ssh-keys/rsa_sysadmin -p 22001 sysadmin@localhost
    ```

## Related Links
- [Ansible Documentation](https://docs.ansible.com/)
- [FrontPage - Debian Wiki](https://wiki.debian.org/FrontPage)
- [Docker Docs](https://docs.docker.com/)
- [creativecommons/sre-salt-prime](https://github.com/creativecommons/sre-salt-prime): Site Reliability Engineering / DevOps SaltStack configuration files
- [creativecommons/index-dev-env](https://github.com/creativecommons/index-dev-env): Local development environment for CreativeCommons.org (reference for docker project)


## License

- [`LICENSE`](LICENSE) (Expat/[MIT][mit] License)

[mit]: http://www.opensource.org/licenses/MIT "The MIT License | Open Source Initiative"
