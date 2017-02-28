## SyncDB

Backups Database A, Exports Database B, and Import's Database B's export into Database A.

### Usage

1. Configure env variables in `syncdb.cfg`
2. Ensure `$saveBackupPath` is writable.
3. run `sh syncdb.sh`

### TODO

1. Exit if any part in the flow fails. I.E, if DB B doesn't export, don't delete DB A.

