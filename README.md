# `mondo` - a theme template manager and generator

SYNOPSIS
--------
`mondo` `-h`|`--help`  
`mondo` `-v`|`--version`  
`mondo` get VARIABLE   
`mondo` `-a`|`--apply` THEME  
`mondo` `-n`|`--new` NAME  
`mondo` [`-f`|`--force`] `-g`|`--generate` THEME|all  
`mondo` [`-f`|`--force`] `-u`|`--update` GENERATOR [THEME]   
`mondo` `-l`|`--list` theme|resource|icon|gtk|cursor   
`mondo` `-t`|`--template` *FILE*|[NAME *FILE*]  

DESCRIPTION
-----------

`mondo` applies variables defined in themefiles to
templates defined in generators. `mondo` executes
userdefined scripts before any theme is applied, 
after each theme is applies and after all themes
are applied. It can also execute a script after each
theme is *generated*.

THEMES
------

Theme files are located in *MONDO_DIR*/themes, to 
create a new theme, use the `-n` option.

The first word of each line is the name of a 
**mondo variable**, the rest of the line (excluding 
white space between the first and the second word) 
will be the value of that variable. Below i create
a simple theme called `example`. (the theme name is
always it's filename.)

``` shell
$ cat << EOF > ~/.config/mondo/themes/example
# example theme
author    Nils Kvist
blue #0000FF
fontface Terminus
EOF
```

*in the example above the theme file is created 
directly, it is strongly recommended to use: *  
`mondo -n THEME` *to create a theme*.  

Lines starting with `#`, will be ignored.
The example above would result in three variables:
  * author="Nils Kvist"
  * blue="#0000FF"
  * fontface="Terminus"

GENERATORS
----------

Generators are located in *MONDO_DIR*/generator.
To create a new generator use the `-t` option. The
only file that is needed for a generator to work is
*_mondo-template*. If a filename was the last argument
when `mondo` was executed with the `-t` (create generator)
option, *_mondo-template* will be a copy of that file.

In the template files, one can use the **mondo variables**
defined in the theme files by typing the name of the
variable enclosed in double (`%%`) percentage characters,
like this:  

``` text
$ cat << EOF > \
  ~/.config/mondo/generator/presentation/_mondo-template
My name is %%author%%, my favorite color is %%blue%%. 
I like to set my terminal font to:("%%fontface%%").
EOF
```

To process this template one can either use:  
`$ mondo -g THEME` this will *generate* (process),
all *_mondo-template* files in each **generator**.
`$ mondo -a THEME` will do the same thing AND apply
the generated files. We could also use:  
`$ mondo -u GENERATOR` this will generate all themes
for a specific GENERATOR.   

Lets say that our *MONDO_DIR* looks like this:  
``` file
~/.config/mondo
  generator/
    presentation/
      _mondo-template (presentation file)
      _mondo-settings
      _mondo-generate
      _mondo-apply
  themes/
    _default
    example
  post-apply
  pre-apply
```

If we where to execute the generate command on the
example theme:  
`$ mondo -g example`  

A file name example would get generated in presentation
directory after that the script *_mondo-generate* would get
executed (the scripts are empty by default).  

``` file
~/.config/mondo
  generator/
    presentation/
      _mondo-template (presentation file)
      _mondo-settings
      _mondo-generate
      _mondo-apply
      example (generated file)
  themes/
    _default
    example (theme file)
  post-apply
  pre-apply
```

`~/.config/mondo/generator/example`:  

``` text
My name is Nils Kvist, my favorite color is #0000FF. 
I like to set my terminal font to:("Terminus").
```

If we now would execute `mondo` with the apply `-a`
option on the `example` theme, the following would happen:  

`$ mondo -a example`  

1. the *pre-apply* script would get executed 
   (empty by default)  
2. if the theme is not generated, it would be generated
   following the same procedure as above, for each generator.  
3. If the variable `target` is set in *_mondo-settings,
   the generated file (*generator/presentation/example*),
   would be copied to the location specified as `target`  
4. *generator/presentation/_mondo-apply* would get executed.
   (*empty by default*)  
5. A file called `MONDO_DIR/themes/.current` is generated
   it contains all variables and is used when `mondo -l var|get`
   is executed.  
6. *post-apply* would get executed  

Most of the autogenerated files have useful comments.  

OPTIONS
-------

`-v`|`--version`  
Show version and exit.

`-h`|`--help`  
Show help and exit.

`-a`|`--apply` THEME  
Apply THEME. The following will happen:  

[`-f`|`--force`] `-g`|`--generate` THEME|all   
Generate THEME. If `-f` is used, any existing generated
files will get overwritten. If all is the argument, all
themes will get generated.

[`-f`|`--force`] `-u`|`--update` GENERATOR [THEME]   
Update GENERATOR. This will update all themes, but 
only for the given GENERATOR. If `-f` is used, any 
existing generated files will get overwritten. If
the last argument is the name of an existing theme,
only that theme will get generated.

`-n`|`--name` NAME  
Create a new theme.  


`-t`|`--template` *FILE*|NAME [*FILE*]   
Create a new generator. If the last argument
is a path to an existing file, that file will be
used to create the template (it will copy the file
to *_mondo-template*, and add the path to the 
target variable in *_mondo-settings*). If a path
is the only argument, the filename without extension
and leading dot will be used as the name for the 
generator.

`-l`|`--list` theme|resource|icon|gtk|cursor|generator 
Prints a list about the argument to stdout.

get VAR  
Prints the value of VAR from the last applied theme
(*MONDO_DIR/themes/.current*).  

FILES
-----

*MONDO_DIR/pre-apply*  
This file get executed BEFORE any other action  
when a THEME is applied (`-a`).   

*MONDO_DIR/post-apply*  
This file get executed AFTER all other actions are    
executed when a THEME is applied (`-a`).  

*_mondo-apply*  
This file is auto generated with each generator.   
It will get executed when a THEME is applied (`-a`).   

*_mondo-generate*  
This file is auto generated with each generator.   
It will get executed when a THEME is generated (`-g`).   

*_mondo-settings*  
This file is auto generated with each generator.   
It contains settings that will affect the generator.  

*_mondo-template*  
This file is auto generated with each generator.   
This is the template file for the generator.  

*themes/_default*  
All user created themes will inherit the content of
this file, it can be used to set common variables.

ENVIRONMENT
-----------

`MONDO_DIR`  
The path to a directory where all mondo files are   
stored. Defaults to `~/.config/mondo`
