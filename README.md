# Emacs Starter Config

![The Final Product](/emacs.png)

## Requirements

There are two main requirements to this emacs config, the two language severs used to power the Go and C completion, they can be installed as such:

```bash:
brew update
brew install ccls
brew install ktlint
brew install go
go get  golang.org/x/tools/gopls
```

The other more obvious requirement is Emacs which can be found at [this website](http://emacsformacosx.com). Dowload version 27.1 for the best results.

## Setup 

You can setup emacs with this config as follows:

```bash:
git clone https://github.com/ramsaycarslaw/emacs_starter_config.git
cp ~/emacs_starter_config/init.el ~/.emacs.d/
```

Once you launch emacs you should see the changes. Finally, you need to install the required icons from within emacs with:

```
M-x all-the-icons-install-fonts RET
```

## Usage

To make emacs feel more modern several tweaks have been made, first `which-key`, which key recognises partially typed commands and shows possible endings for them. Second a file tree like VsCode, this can be accessed by pressing `f8` or `Cmd+b`.

## Supported Languages

* C - Full language sever support, completions, err check, jump to def...
* Go - Full language sever support, completions, err check, imports and formating ...
* Python - Full autocomplete and format support
* Kotlin - Full autocomplete and Error checking
