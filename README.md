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
<p>3.Download Power Script files and put inside go-sm folder<br>
  &emsp;Your folder should look like this:<br>
  <img src="https://github.com/xeliuqa/PowerScript/blob/main/assets/folder.jpg" height="300px" width="300px"/></p>
<p>4.Disable Powershell Remote security.</p>
<p>&emsp;-Open Powershell in admin and insert code<br></p>
<p$${\color{green}>&emsp;&emsp;Set-ExecutionPolicy RemoteSigned</p>
<p>5. Edit Settings.ps1 with a file editor. I recommend NotePad++</p>
</div>

<img src="https://github.com/xeliuqa/PowerScript/blob/main/assets/settings.png" height="200px" width="600px"/>
<p>You can also edit advance settings if you know what you are doing</p>
<p>When finished editing settings, save,close and double click "node.cmd"</p>
<p>If not present, Power Script will create PoST folder and Log file for you</p><br>

<h1>Note:</h1>
`This version does not require config-mainnet.json but if you are a advance user you can still use a custom config file`

addOns
===
###[Disable PowerShell security](#Disable-PowerShell-security)
```json
Set -ExecutionPolicy -RemoteSigned
```




