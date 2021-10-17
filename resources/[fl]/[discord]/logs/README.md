<h1 align="center">
	JOIN THE DISCORD FOR SUPPORT
</h1>

<img src="https://i.gyazo.com/3894b03d4351bcb566ec85afc7f9b231.png">

<h4 align="center">
	<a href="https://github.com/JokeDevil-com/JD_logs/releases/latest" title=""><img alt="Licence" src="https://img.shields.io/github/release/JokeDevil-com/JD_logs.svg"></a>
	<a href="LICENSE" title=""><img alt="Licence" src="https://img.shields.io/github/license/JokeDevil-com/JD_logs.svg"></a>
	<a href="https://discord.gg/m4BvmkG" title=""><img alt="Discord Status" src="https://discordapp.com/api/guilds/721339695199682611/widget.png"></a>
</h4>

<h4 align="center">
This is a server log script for FiveM, which is used to log certain actions that are being made in the server.
</h5>

### 🛠 Requirements
- A Discord Server
- FXServer

### ✅ Main Features
- Basic logs:
  - Chat Logs (Messages typed in chat)
  - Join Logs (When i player is connecting to the sever)
  - Leave Logs (When a player disconnects from the server)
  - Death Logs (When a player dies/get killed)
  - Shooting Logs (When a player fires a weapon)
  - Resource Logs (When a resouce get started/stopped)
- Plugin Support
  - Easy way to add more logs to JD_logs with plugins. (More plugins will be released soon!)
- Optional custom logs
  - Easy to add with the export.

### 🔧 Download & Installation

1. Download the files
2. Put the JD_logs folder in the server resource directory
3. Add this to your `server.cfg`
```
ensure JD_logs
```

### 📝 Creating Custom Logs

1. Add the following code to your function/command.<br>
*This code needs to be added in the resource of the action you want to log.*
```
exports.JD_logs:discord('EMBED_MESSAGE', PLAYER_ID, PLAYER_2_ID, 'COLOR', 'WEBHOOK_CHANNEL')
```
`EMBED_MESSAGE`: This will be the message send in the top of the embed.<br>
`PLAYER_ID`: This will send the player to the script to get the info. (This needs to be a server id)<br>
`PLAYER_2_ID`: This will send the second player's to the script to get the info. (This needs to be a server id)<br>
`COLOR`: This will be the color of the embed. (You can use Decimal colors or Hex colors.)<br>
`WEBHOOK_CHANNEL`: This will be the webhook channel listed in the config.lua.<br>


2. Create a discord channel with webhook and add this to the webhooks.
```
local webhooks = {
	all = "DISCORD_WEBHOOK",
	chat = "DISCORD_WEBHOOK",
	joins = "DISCORD_WEBHOOK",
	leaving = "DISCORD_WEBHOOK",
	deaths = "DISCORD_WEBHOOK",
	shooting = "DISCORD_WEBHOOK",
	resources = "DISCORD_WEBHOOK",
	WEBHOOK_CHANNEL = "DISCORD_WEBHOOK", <------
}
```
*This can be found in the `config.lua`*

### ❓ For more questions you can join the discord here: https://discord.gg/m4BvmkG

<details>
  <summary>📦 Change Log</summary>
	<br>

<details>
<summary>V1.3.0</summary>
• Added Plugin Support<br>
</details>
<summary>V1.1.6</summary>
• Fixed Death logs issue<br>
</details>
<details>
<summary>V1.1.5</summary>
• Bug fix/code clean up<br>
</details>
<details>
<summary>V1.1.4</summary>
• Bug fixes<br>
</details>
<details>
<summary>V1.1.3</summary>
• Bug fixes<br>
</details>
<details>
<summary>V1.1.2</summary>
• Added: License Identifier <code>Config.license = true</code> <br>
• Added: Player IP address <code>Config.IP = true</code><br>
</details>
<details>
<summary>V1.1.1</summary>
• Added hex color code support. (Old decimal color codes will still work.)<br>
• Added option to hide player info on exports. (Very simple just change the PLAYER_ID to 0 and it wont show any info.)
</details>
<details>
<summary>V1.1.0</summary>
• Reworked Export function. (Now with identifier support)<br>
</details>
<details>
<summary>V1.0.4</summary>
• Added Nearest Postal For This Postal Map<br>
• Added check if the identifier is available ( Prevents some errors :slight_smile: )<br>
• Fixed some small bugs<br>
</details>
<details>
<summary>V1.0.3</summary>
• Added Discord Identifier<br>
• Added Steam Profile URL<br>
• Fixed Death Reason<br>
• Player commited suicide<br>
• Player was murdered<br>
• Player Died (Other reasons like getting run over or random explosions)<br>
</details>
<details>
<summary>V1.0.2</summary>
• Added more Customizations<br>
&nbsp;&nbsp;• Bot's Username<br>
&nbsp;&nbsp;• Bot's Avatar<br>
&nbsp;&nbsp;• Embed Community Name<br>
&nbsp;&nbsp;• Embed Community Logo<br>
• Color settings for default Events<br>
• Added Player ID to default Events<br>
• Added Option to enable/disable Player ID<br>
• Added option to enable/disable Steam ID<br>
</details>
<details>
<summary>V1.0.1</summary>
• Added option to disable Shooting Logs<br>
</details>
<details>
<summary>V1.0.0</summary>
• All log channel<br>
• Log to seperate channels<br>
• Log from server or client side<br>
• Easy changeble Avatar and Username<br>
</details>
</details>
