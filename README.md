# sensu-plugins
- Export Container global variables.

    - `a` - The server's IP Address.
    - `n` - The server's hostname.
    - `h` - The rabbitmq host

- Set the LDAP credentials and load environment variables.

    ```bash
	chmod +x install-sensu-client.sh && \
	chmod +x linux-plugins/basic/*.rb && \
    chmod +x linux-plugins/*.rb 
	
    ./install-sensu-client.sh -a <CLIENT_ADDRESS> -n <CLIENT_NAME> -h <RABBITMQ_HOST>
    ```