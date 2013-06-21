There's a few things I think suck:

- JDBC uses ? as a bind parameter marker rather than $0, $1, $2.
- Meaning queries we create that have $... in the name will break (identifiers with $ seem to be valid in pg but not in sql standard)
- Have to special case the setup code since this runs through Conn.execute, but is evaluated on backend rather than by jdbc

- Must distinguish between SELECT queries and not,
  since JDBC has statement.executeQuery vs. statement.execute.


To do:
Add a QC::THREADS option. Defaults to 1 or is ineffectual? on MRI.
Dispatch threads using some ThreadPool thing, figure out how to make this isolated in jruby side.

Update documentation, for example, LISTEN/NOTIFY is not supported by JDBC.

jruby-pg gem, maybe.
