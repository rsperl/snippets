In tasks.json:

```json
{
  "tasks": [
    {
      "taskName": "Find TODOs in this file",
      "command": "ag",
      "args": [
        "--vimgrep",
        "--no-color",
        "-i",
        "#\\s*todo|#\\s*hack|#\\s*fixme|//\\s*todo|//\\s*hack|//\\s*fixme"
      ],
      "isBackground": false,
      "showOutput": "always"
    }
  ]
}
```
