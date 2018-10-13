# sqlhelpers

Functions for simplifying the retrieval of data from Sql databases.

This package exports two functions: `queryDb` and `queryDbFromFile`.
These two functions allow a user to run a query against a database,
handling the connection and disconnection from the server as well as
interpolation of any sql parameters.

To run a query against a database, the server must first have an ODBC
DSN configured. The name of the DSN becomes the "server" parameter
to the `queryDb` and `queryDbFromFile` functions. You can find
details of how to create a DSN in [Windows here](https://docs.microsoft.com/en-us/sql/relational-databases/native-client-odbc-how-to/configuring-the-sql-server-odbc-driver-add-a-data-source?view=sql-server-2017).

It is simple to use parameters in your sql queries. Where you wish to
use a parameter, simply enter a ? followed by the name of the parameter.
For each parameter that you use, you must then specify in the call to
the function each parameter with it's value. For example,

```R
sql <- "SELECT * FROM MyTable WHERE Id = ?id"

queryDb("Server", "Database", sql, id = 1)
```

Alternatively, you can create the parameters as a list

```R
params <- list(id = 1)

queryDb("Server", "Database", sql, id = 1)
```
