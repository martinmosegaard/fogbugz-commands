# Logon

```sh
curl https://mysite.fogbugz.com/f/api/0/jsonapi -d '{"cmd":"logon","email":"my@email.com","password":"changeme"}'
{"data":{"token":"somealphanumericcharacters"},"errors":[],"warnings":[],"meta":{"jsdbInvalidator":"anothertoken","clientVersionAllowed":{"min":4,"max":4}},"errorCode":null,"maxCacheAge":null}
```
