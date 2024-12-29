# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

# How to run the application via docker (standalone)
1. To build and run autonium and db containers
    # (standalone)
   ```docker-compose -f docker-compose-standalone.yml up```
   # (docker-compose.yml present)
   ```docker-compose up```

2. To seed the data (required after first run)

   ```docker-compose exec autonium rake db:seed```

3. To bring all the containers down

   ```docker-compose down```

4. To build only autonium containers
   # (standalone)
   ```docker-compose -f docker-compose-standalone.yml build autonium```
   # (docker-compose.yml present)
   ```docker-compose build autonium```

5. To bring up db instance only

   ```docker-compose up db```

6. To execute rails console

   ```docker-compose exec autonium rails console```

7. To execute rails dbconsole

   ```docker-compose exec autonium rails dbconsole```

8. To get shell access on oregano

   ```docker-compose exec autonium sh```

9. To access db's mysql over host

   ```mysql -u root -p root -h 127.0.0.1 -P 3307```

10. To access rails credentials for develop environment

    ```rails credentials:show```

    To update credential file ```credentials.yml.enc```  run below command inside container bash and add valid tokens,
    keys and values and save it.

    ```EDITOR=vim rails credentials:edit```

11. To access ```RAILS_MASTER_KEY``` please get in touch with your team.
