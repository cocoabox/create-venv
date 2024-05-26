# About this project

I found out that python venvs are not quite portable:

- they OS-dependent (i.e. a venv created on macOS will tno work on linux)
- they are vulnerable to `mv` (directory moving) because the python interpreter inside the venv is hard-coded

To overcome these, I have created some bootstrapping bash scripts that will mitigate these issues. 
The result is a "workspace" that contains the **app** and **multiple venvs (one per OS)**. 

A bootstrapping bash script is run every time to activate/create the venv required. The script also detects if the venv's directory has been changed; if so it updates the dir reference in the venv.
 
An example of using the bootstrapping script:

```
❯❯ ./run-app.sh
--> inspecting shebang of /tmp/my-venv/venvs/macos/bin/pip
    dir reference to '/tmp/my-venv/venvs/macos' looks good
--> activating : /tmp/my-venv/venvs/macos/bin/activate
==> python3 is : /tmp/my-venv/venvs/macos/bin/python3
==> running...
hello world
```

Notice that the venv is automatically activated.

# instructions

### creating a workspace

1. prepare your requirements.txt 
1. run `./create-venv.sh [DIR_NAME]`
	- specify the python version to use; it must be already installed on your OS
	- edit requirements.txt
	- confirm workspace creation 

<details><summary>example</summary>

```
$ ./create-venv.sh /tmp/my-venv
python version [Return=3.12] :
---
# requirements (e.g. mylib==1.2.3)
aiohttp==3.9.0
---
use the above requirements.txt [y/Return=OK, else=edit again] :
--> creating venv /tmp/my-venv
sending incremental file list
python-ver
requirements.txt
venvs/

sent 726 bytes  received 64 bytes  1.58K bytes/sec
total size is 5.54K  speedup is 7.02
/var/folders/3z/w19z53_576nbspc7d0mfcp_40000gp/T/tmp.N7LCHdpC/requirements.txt -> /tmp/my-venv/requirements.txt
Python 3.12.3
ok! got 3.12.3
python3.12
found existing venv dir
updating path reference
--> inspecting shebang of /tmp/my-venv/venvs/macos/bin/pip
    dir reference to '/tmp/my-venv/venvs/macos' looks good
thanks
$
```
</details>

### (optional) creating venvs

venvs are created automatically and normally do not require explicit creation, but if you really want to:

- run `venvs/create-venv.sh`
	- this will create the venv for your OS, then install all requirements 
	
<details><summary>example</summary>

```
❯❯ ./venvs/create-venv.sh
Python 3.12.3
ok! got 3.12.3
python3.12
creating venv...
installing requirements...
Collecting aiohttp==3.9.0 (from -r /tmp/my-venv/venvs/../requirements.txt (line 2))
  Downloading aiohttp-3.9.0-cp312-cp312-macosx_10_9_x86_64.whl.metadata (7.4 kB)
Collecting attrs>=17.3.0 (from aiohttp==3.9.0->-r /tmp/my-venv/venvs/../requirements.txt (line 2))
  Using cached attrs-23.2.0-py3-none-any.whl.metadata (9.5 kB)
Collecting multidict<7.0,>=4.5 (from aiohttp==3.9.0->-r /tmp/my-venv/venvs/../requirements.txt (line 2))
  Using cached multidict-6.0.5-cp312-cp312-macosx_10_9_x86_64.whl.metadata (4.2 kB)
Collecting yarl<2.0,>=1.0 (from aiohttp==3.9.0->-r /tmp/my-venv/venvs/../requirements.txt (line 2))
  Using cached yarl-1.9.4-cp312-cp312-macosx_10_9_x86_64.whl.metadata (31 kB)
Collecting frozenlist>=1.1.1 (from aiohttp==3.9.0->-r /tmp/my-venv/venvs/../requirements.txt (line 2))
  Using cached frozenlist-1.4.1-cp312-cp312-macosx_10_9_x86_64.whl.metadata (12 kB)
Collecting aiosignal>=1.1.2 (from aiohttp==3.9.0->-r /tmp/my-venv/venvs/../requirements.txt (line 2))
  Using cached aiosignal-1.3.1-py3-none-any.whl.metadata (4.0 kB)
Collecting idna>=2.0 (from yarl<2.0,>=1.0->aiohttp==3.9.0->-r /tmp/my-venv/venvs/../requirements.txt (line 2))
  Using cached idna-3.7-py3-none-any.whl.metadata (9.9 kB)
Downloading aiohttp-3.9.0-cp312-cp312-macosx_10_9_x86_64.whl (392 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 392.4/392.4 kB 5.9 MB/s eta 0:00:00
Using cached aiosignal-1.3.1-py3-none-any.whl (7.6 kB)
Using cached attrs-23.2.0-py3-none-any.whl (60 kB)
Using cached frozenlist-1.4.1-cp312-cp312-macosx_10_9_x86_64.whl (53 kB)
Using cached multidict-6.0.5-cp312-cp312-macosx_10_9_x86_64.whl (29 kB)
Using cached yarl-1.9.4-cp312-cp312-macosx_10_9_x86_64.whl (81 kB)
Using cached idna-3.7-py3-none-any.whl (66 kB)
Installing collected packages: multidict, idna, frozenlist, attrs, yarl, aiosignal, aiohttp
Successfully installed aiohttp-3.9.0 aiosignal-1.3.1 attrs-23.2.0 frozenlist-1.4.1 idna-3.7 multidict-6.0.5 yarl-1.9.4
moving venv to /tmp/my-venv/venvs and updating permissions...
updating path reference
--> inspecting shebang of /tmp/my-venv/venvs/macos/bin/pip
--> updating venv dir reference : /private/var/folders/3z/w19z53_576nbspc7d0mfcp_40000gp/T/tmp.LvJ9yBoB/macos ---> /tmp/my-venv/venvs/macos
thanks
```

</details>

# running your apps

edit the bootstrapping script `app/run-app.sh` to add your python app's main program to the bootstrapping script.

- run-app.sh will activate the venv before running your app 
- if the venv for your OS does not exist, it'll be created

<details><summary>example</summary>

```
❯❯ ./run-app.sh
--> inspecting shebang of /tmp/my-venv/venvs/macos/bin/pip
    dir reference to '/tmp/my-venv/venvs/macos' looks good
--> activating : /tmp/my-venv/venvs/macos/bin/activate
==> python3 is : /tmp/my-venv/venvs/macos/bin/python3
==> running...
hello world
```
</details>