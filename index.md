![CI](https://github.com/awinecki/envo/workflows/CI/badge.svg?branch=main)

`envo` is a bash CLI helper for loading `.env` (dotenv) as environment variables into any program.

[![asciicast](https://asciinema.org/a/Tn95ATBxcSx0srPFg6mccPCPo.svg)](https://asciinema.org/a/Tn95ATBxcSx0srPFg6mccPCPo)


It's a simple bash script that can come in handy when working with environment variables, testing stuff out, etc.

## Install

```
curl https://raw.githubusercontent.com/awinecki/envo/main/envo.sh --output ~/.local/bin/envo --create-dirs && chmod +x ~/.local/bin/envo
```

*Uninstall*

```
rm ~/.local/bin/envo
```



## Usage

```
envo <command>
```

Any *command* now has access to all env vars defined in `.env` file.



## Pros

- Tested with shellspec
- Just bash, can work almost anywhere
- Fast, almost no overhead
- No need to use libraries for `.env` loading
- Works in `zsh`, `bash`, `fish` (others probably too, but haven't tested)



### Why not just use a simple `bashism` for this

There are ways to accomplish this with pure bash / sh, like this:

```
export (cat .env | xargs) && cmd
```

However, I've found this approach lacking:

- It doesn't work in all terminals the same (I'm using `fish`)
- Honestly who remembers this xargs piping spaghetti
- I like good CLI api, and *prepending* my command with a handy tool that loads env vars resonates with me



## Features

#### Specify env file (other than the default `.env`)

```
envo -f /path/to/.custom.env <my_command>
```

#### Add more env vars

```
envo -e SOMEVAR=VALUE -e ANOTHER=SECRET <my_command>
```

For more info, type `envo --help`.
