Given json data like

```shell
data='{
	"message":"List of orders",
    "data":[
    	{"siteNum":"70293591","siteName":"VIYA 4 TESTING RICHARD SUGG REQ RITM0288018","number":"9CMW3K","date":"2021-11-29T17:09:10-05:00","updateStatus":"noUpdateAvailable","features":[],"downloadStatus":"ok","accessRole":"owner"},
        {"siteNum":"70180938","siteName":"Richard test","number":"9CPWF3","date":"2022-04-19T12:24:42-04:00","updateStatus":"noUpdateAvailable","features":[],"downloadStatus":"ok","accessRole":"owner"},
        {"siteNum":"70180938","siteName":"testing viya 4 order","number":"09YYND","date":"2021-10-11T13:52:08-04:00","updateStatus":"noUpdateAvailable","features":[],"downloadStatus":"ok","accessRole":"user"},
        {"siteNum":"70180938","siteName":"viya 4 test 6 - 04aug21","number":"09XZF5","date":"2021-08-04T13:51:49-04:00","updateStatus":"updateAvailable","features":[],"downloadStatus":"ok","accessRole":"user"}
    ]
}'
```

jq can flatten like

```shell
echo $data |
  jq '[leaf_paths as $path | {
    "key": $path | join("."), "value": getpath($path)
}] | from_entries'
```

output:

```text
{
  "message": "List of orders",
  "data.0.siteNum": "70293591",
  "data.0.siteName": "VIYA 4 TESTING RICHARD SUGG REQ RITM0288018",
  "data.0.number": "9CMW3K",
  "data.0.date": "2021-11-29T17:09:10-05:00",
  "data.0.updateStatus": "noUpdateAvailable",
  "data.0.downloadStatus": "ok",
  "data.0.accessRole": "owner",
  "data.1.siteNum": "70180938",
  "data.1.siteName": "Richard test",
  "data.1.number": "9CPWF3",
  "data.1.date": "2022-04-19T12:24:42-04:00",
  "data.1.updateStatus": "noUpdateAvailable",
  "data.1.downloadStatus": "ok",
  "data.1.accessRole": "owner",
  "data.2.siteNum": "70180938",
  "data.2.siteName": "testing viya 4 order",
  "data.2.number": "09YYND",
  "data.2.date": "2021-10-11T13:52:08-04:00",
  "data.2.updateStatus": "noUpdateAvailable",
  "data.2.downloadStatus": "ok",
  "data.2.accessRole": "user",
  "data.3.siteNum": "70180938",
  "data.3.siteName": "viya 4 test 6 - 04aug21",
  "data.3.number": "09XZF5",
  "data.3.date": "2021-08-04T13:51:49-04:00",
  "data.3.updateStatus": "updateAvailable",
  "data.3.downloadStatus": "ok",
  "data.3.accessRole": "user"
}
```
