# sensu-plugins
- Export Container global variables.

    - `c` - The client name. 
    - `a` - The server's IP address.
    - `n` - The server's hostname.
    - `h` - The rabbitmq host

- Set the LDAP credentials and load environment variables.

    ```bash
	chmod +x install-sensu-client.sh && \
	chmod +x linux-plugins/basic/*.rb && \
    chmod +x linux-plugins/*.rb 
	
    ./install-sensu-client.sh -c <CLIENT_NAME> -a <SERVER_ADDRESS> -n <SERVER_NAME> -h <RABBITMQ_HOST>
    ```
