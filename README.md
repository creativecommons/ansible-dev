# ansible-dev


## Code of Conduct

[`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md):
> The Creative Commons team is committed to fostering a welcoming community.
> This project and all other Creative Commons open source projects are governed
> by our [Code of Conduct][code_of_conduct]. Please report unacceptable
> behavior to [conduct@creativecommons.org](mailto:conduct@creativecommons.org)
> per our [reporting guidelines][reporting_guide].

[code_of_conduct]: https://opensource.creativecommons.org/community/code-of-conduct/
[reporting_guide]: https://opensource.creativecommons.org/community/code-of-conduct/enforcement/


## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md).


### Goals

The aim of the project is to establish a robust and localized development environment utilizing Ansible and Docker. This environment will mirror a professional work setting, incorporating a dedicated security server (Bastion), automation through Ansible, a web server, and a data storage server. This configuration will simplify and secure development processes and serve as a blueprint for future projects at CC.

Docker containers:

- Bastion (SSH jump server)
- Ansible
- Web server (Apache2/WordPress)
- Database server (MariaDB)

```mermaid
graph LR
    A[Ansible server] -->|manages| B[webserver 1 (Apache2/Wordpress)]
    A -->|manages| C[webserver 2 (nginx)]
    A -->|manages| D[webserver n]
    B --> E[Database server 1]
    C --> F[Database server 2]
    D --> G[Database server n]
    H[Bastion server] -.->|secure access| A
    H -.->|secure access| B
    H -.->|secure access| C
    H -.->|secure access| D


See [Create Local Ansible Dev Environment Using Docker](https://opensource.creativecommons.org/programs/project-ideas/#ansible-dev-env) for more details.


## Related Links
- [Ansible Documentation](https://docs.ansible.com/)
- [FrontPage - Debian Wiki](https://wiki.debian.org/FrontPage)
- [Docker Docs](https://docs.docker.com/)
- [creativecommons/sre-salt-prime](https://github.com/creativecommons/sre-salt-prime): Site Reliability Engineering / DevOps SaltStack configuration files
- [creativecommons/index-dev-env](https://github.com/creativecommons/index-dev-env): Local development environment for CreativeCommons.org (reference for docker project)


## License

- [`LICENSE`](LICENSE) (Expat/[MIT][mit] License)

[mit]: http://www.opensource.org/licenses/MIT "The MIT License | Open Source Initiative"
