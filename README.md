# PowerScript
Power Script is the work of Spacemesh contributors Jonh and Sakki.<br>
It was made to help beginners run the go-sm node for spacemesh.<br>
It automates 95% of the process of running a node and helps with readability through colors<br>
<br>
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/IF4jAciMn0o/0.jpg)](https://www.youtube.com/watch?v=IF4jAciMn0o)
<br>
<br>
<div id="How to:" class="tabcontent">
<p>1. Download latest go-spacemesh node <a href="https://github.com/spacemeshos/go-spacemesh/releases">go-spacemesh</a></p>
<p>2. Create folder and unzip go-sm contents inside<br></p>
<p>3. Download <a href="https://configs.spacemesh.network/config.mainnet.json">config.mainnet.json</a></p>
<p>&emsp;Edit ports and save inside same go-sm created above<br></p>
<p>4.Download Power Script files and put inside go-sm folder<br>
  &emsp;Your folder should look like this:<br>
  <img src="https://github.com/xeliuqa/PowerScript/blob/main/assets/folder.jpg" height="300px" width="300px"/></p>
<p>5.Disable Powershell Remote security.</p>
<p>&emsp;-Open Powershell in admin and insert code<br></p>
<p$${\color{green}>&emsp;&emsp;Set-ExecutionPolicy RemoteSigned</p>
<p>6. Edit Settings.ps1 with a file editor. I recommend NotePad++</p>
</div>

<img src="https://github.com/xeliuqa/PowerScript/blob/main/assets/settings.png" height="200px" width="600px"/>
<p>You can also edit advance settings if you know what you are doing</p>
<p>When finished editing settings, save,close and double click "node.cmd"</p>
<p>If not present, Power Script will create PoST folder and Log file for you</p>


addOns
===
###[Disable PowerShell security](#Disable-PowerShell-security)
```json
Set -ExecutionPolicy -RemoteSigned
```
### Mainnet config settings
 ```json
 "smeshing": {
    "smeshing-opts": {
        "smeshing-opts-maxfilesize":2147483648,
        "smeshing-opts-provider":4294967295,
        "smeshing-opts-numunits":16,
        "smeshing-opts-compute-batch-size":1048576
      },
    "smeshing-proving-opts": {
        "smeshing-opts-proving-nonces":288,
        "smeshing-opts-proving-threads":5
      }
  }
```


