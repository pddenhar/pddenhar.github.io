---
layout: post
title: Migrating a Subsonic Database from HSQLDB to MySQL
custom_css: syntax.css
---
The [Subsonic](http://www.subsonic.org/pages/index.jsp) project recently added support for databases other than the built in HSQL database that has always been packaged with the Subsonic server. My Subsonic server manages about 40,000 media files and has ~40 users with hundreds of favourites and ratings. It was starting to perform slowly and index scans in particular were taking ~3 hours, so I was looking forward to moving away from the outdated HSQLDB system to MySQL.

Unfortunately, at this time there is no built in tool for migrating a Subsonic server's data, which would have meant losing hundreds of favorited songs, user preferences, and passwords. To remedy this, I created the [Subsonic Database Migration Tool](https://github.com/pddenhar/Subsonic-DB-Migration-Tool). Theoretically it should be able to migrate a Subsonic database from any JDBC connection to another one, but I have only tested it with JDBC and MySQL.

Full instructions are on my GitHub page, but the short version is thus:

1. Make sure your new database server is up and running
2. Follow the instructions on http://www.subsonic.org/pages/database.jsp to connect your existing 
Subsonic installation to the empty database. 
3. Run Subsonic at least once to initialize the new database with empty tables.
4. Open the project in IntelliJ, open Main.java and change the `OLD_DB_URI`, `NEW_DB_URI`
   and the two passwords.
   * `OLD_DB_URI` should point to your existing HSQLDB database (/var/subsonic/db/subsonic on Linux).
5. Run the project in IntelliJ and the data will be migrated from your old database to the new one,
leaving your old database unchanged.