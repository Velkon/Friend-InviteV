This is an addon for referring people to your serer, directly based off of *another* scriptfodder addon.

You can view the serverside file for configs and shit.

>inb4 Copy paste

Features:
Quick menu to select who invited you
Checks if they are steam friends
Requires a timeconnection limit
Change the reward to anything you want
Lightweight.
Prevents from rewarding anymore inviters after the first.
Chat advert included.
Uses steam API.

Simple Setup:
Drop into your addons folder
Update the configs with your api key.
Restart server and it's done, hopefully your server will have generate more players!
Reward examples
You can add any type of reward you want Place this in your config function for the reward.

Add a ulx rank: game.ConsoleCommand("ulx adduserid "..ply:SteamID().." yourrankname\n" )
Give RP Money ply:addMoney(50000)
Pointshop ply:PS_GivePoints(5000)
