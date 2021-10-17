## Informations

Ceci est un leak de la base FreeLife qui elle est construite avec la base de FlashLand V6

Voici les raisons pour lesquelles j'ai créé ce repo Github

- J'ai fait un ménage du SQL qui contenant plein d'informations inutiles
- Les autres leaks demandent toujours de rejoindre des serveurs discord rempli de trucs inutiles pour obtenir un mot de passe
- Cette base étant déjà leak, je ne fais que fournir une version plus propre de celle-ci
- server.cfg plus propre
- La base a été scanné pour éviter qu'un backdoor Cipher ai été installé.

## Installation

**Voici quelques petites choses à faire une fois la base téléchargée.**  

- Mettez à jour la license FiveM dans le fichier `server.cfg` et remplissez les informations que vous désirez.

- Importez le fichier `flashland.sql` dans votre base de données et mettez à jour la ligne 

- Rendez-vous dans resource `report` qui est directement à la racine du dossier `resources`
- Ajoutez les admins que vous désirez dans le `local reportadmin`  (Voir l'exemple ci-dessous)

```lua
local reportadmin = {
    'discord:000000000000',
    'steam:111111111111',
}
```


- Rendez-vous dans la resource `fl_discordwhitelist` qui de trouve dans le dossier `resources/[discord]`
- Complété le fichier `config.lua` avec les informations de votre propre bot discord pour utiliser le whitelist Discord (Voir l'exemple ci-dessous)

```lua
Config = {
	DiscordToken = "XXXXXXX",
	GuildId = "00000000",
	WhitelistedRoles = {},

Roles = {
		["Citoyen(ne)"] = "0000000000"
	}
}
```


- Rendez-vous dans la resource `logs` qui se trouve dans le dossier `resources/[discord]`
- Complétez la section `Config.webhooks` du fichier `config.lua` en ajoutant vos propres webhooks discord (Voir l'exemple ci-dessous)

```lua
Config.webhooks = {
	all = "",		-- All logs will be send to this channel
	chat = "",		-- Chat Message
	joins = "",		-- Player Connecting
	leaving = "",	-- Player Disconnected
	deaths = "",		-- Shooting a weapon
	shooting = "",	-- Player Died
	resources = "DISCORD_WEBHOOK",	-- Resource Stopped/Started	
}
```

* Rendez-vous dans la resource `fl_billing` qui se trouve dans le dossier `resources/[fl]/[esx]/[base]`
  * Modifiez les 2 webhooks aux lignes 22 et 33 dans le fichier `fl_billing/server.lua`. 
  * Ce sont des logs pour la facturation.

- Rendez-vous dans la resource `fl_bans` qui se trouve dans le dossier `resources/[fl]/[core]`
> Modifiez les 2 webhooks aux lignes 3 et 4 du fichier `fl_bans/config.lua`. 
- Ce sont des logs pour les bans et unbans.

- Rendez-vous dans la resource `fl_society` qui se trouve dans le dossier `resources/[fl]/[esx]/[base]`
- Modifiez le webhook qui se trouve à la ligne 8 du fichier `fl_society/server/ads.lua`
- Ce sont pour les logs des annonces du menu f5 pour les entreprises et le twitter.

- Rendez-vous dans la resource `es_extended` qui se trouve dans le dossier `resources/[fl]/[esx]`
- Modifiez les 2 webhooks aux lignes 276 et 287 du fichier `es_extended/server/main.lua`. 
- Ce sont pour les logs des gives d'items.

- Rendez-vous dans la resource `fl_bank` qui se trouve dans le dossier `resources/[fl]/[jobs]`
- Modifiez les 2 webhooks aux lignes 50 et 61 du fichier `fl_bank/server/sv_bank.lua`. 
- Ce sont pour les logs des transferts d'argent.


### Choses à savoir

- Cette base utilise un Framework personnalisé ce qui veut dire que si vous importez/exportez des resources, vous devrez vous assurer d'utiliser les bonnes méthodes d'importation du ESX.
- Il est possible qu'il manque plusieurs streams comme des véhicules ou mapping. C'est à vous de faire la recherche. N'hésitez pas à ouvrir un [issue](https://github.com/fasterplayer/Flash-Land/issues) discord si vous découvrez une erreur afin que je puisse la corriger pour les futurs utilisateurs.


## Vous cherchez le meilleur bot pour votre serveur RP?
[CapriceBot](https://capricebot.com) (Développé par moi et utilisé par plus de 250 serveurs).

## Vous cherchez un hébergeur?
[Caprice Hosting](https://capricehost.com)

## Besoin d'aide?
Contactez moi via mon serveur Discord [Faster](https://discord.gg/UwfF6e3yfT)