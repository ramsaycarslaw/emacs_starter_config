# Emacs Starter Config

> Emacs for the 21st century

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

| Shortcut | Effect                |
| :--------| --------------------: |
| Cmd + B  | Open File Tree        |
| Cmd + F  | Find (helm-find-file) |
| M-,      | Go build package      |

## Supported Languages
Out of the box this config supports man languages
### C  
Full language sever support, completions, err check, jump to def...
![C Snippets](/c.gif)
### Go 
The Go binding features:
* A go language sever
* Intelligent completions
* Auto formatting and imports
* Compile project bound to `M-,`
![Go Screenshot](/go.png)
### Python 
Full langux1age sever support, identical to VsCode
![Python Snippets](/py.gif)
### Kotlin 
Full autocomplete and Error checking
#### XML 
XML is also supported as part of kotlin with tag rename and code folding
### Haskell  
Very minor support with just haskell mode
