# Upgrading from Legacy Server

## Require

The `require` keyword does not exist anymore and will throw an error on fxserver. You should remove all references to
require, there is no replacement as this is no longer useful.

However you will have to add this line to your resource file `__resource.lua` in order to have access to the mysql async:

```lua
server_script '@mysql-async/lib/MySQL.lua'
```

## Configuration

There is no more configuration file in this lib, instead it use directly a `conv_var` which is basically a variable set
in the configuration file of your fxserver `server.cfg`

So you can remove the config file that you were having and add this line into your `server.cfg` file :

```
set mysql_connection_string "server=mariadb;database=fivem;userid=root;password=fivem"
```

It is highly recommended to set those variable **before** starting modules so they will be available directly on startup
(even if we provide some safety check for someone defining this var after...)

## Startup code with queries

You may have some sql queries at the start of your module, however due to the new way of loading modules in fxserver
(which is somehow async): Your library can be loaded before mysql-async even if you start it after.

To handle this use case, this library provide a special event `onMySQLReady` that is emitted once it's loaded, so you can do:

```lua
AddEventHandler('onMySQLReady', function ()
    -- Startup code using mysql
end)
```



