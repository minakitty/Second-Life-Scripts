// *********************************************************
// HUD Auto Control Script - v 0.2
// (c) 2017 Heather-Lynne Van Wilde (Sonja.Redangel@SL)
// Under the GNU Affero GPL, V 3.0, 19-Nov-2007
// https://www.gnu.org/licenses/agpl-3.0.en.html
//
// Script repository:
// https://github.com/minakitty/Second-Life-Scripts
//
// Requires an RLV/RLVa capable viewer that supports @detach,
// @attachallover and @getinvworn functions (version 2.1.2)
//
// Scans for active HUD's in specific folders (under the
// #RLV/~HUD folder) and gives the user the option to attach
// and detach the folders on command.
// 
// ***WARNING: Very much a work in progress, any deviations
// from the file structure documented will require a complete
// rewrite of the script.  Code improvements are planned for
// future versions.
// *********************************************************

// RLV listen handles
integer chanKemonoBody;
integer chanKemonoHead;
integer chanKemonoHeels;
integer chanKemonoMaid;
integer chanPonyAO;
integer chanZeonWing;

//RLV feedback status (ON|OFF|PART ON)
string statKemonoBody;
string statKemonoHead;
string statKemonoHeels;
string statKemonoMaid;
string statPonyAO;
string statZeonWing;

//other variables
integer feedback;
list dialogGrid = ["KM Maid","KM Heels","ZEON Wing","Pony AO","KM Head","KM Body"];
string dialogStat;
integer chanDialog; //randomized channel for listening to llDialog
integer chanTrigger; //listen handle for llDialog

build_menu()
{
    dialogStat = "Current HUD status:\n Pony AO: " + statPonyAO + "\n Kemono Head: " + statKemonoHead + "\n Kemono Body: " + statKemonoBody + "\n Kemono Maid: " + statKemonoMaid + "\n Kemono Heels: " + statKemonoHeels + "\n ZEON Wing: " + statZeonWing;
    chanDialog = (integer)(llFrand((-1000000000.0) - 1000000000.0));
    llDialog(llGetOwner(), dialogStat, dialogGrid, chanDialog);
    chanTrigger = llListen(chanDialog, "", llGetOwner(), "");
}

default
{
    state_entry()
    {
        llOwnerSay("Initializing Systems");
    }

    touch_start(integer total_number)
    {
        llOwnerSay("Scanning");
        feedback=0;
        //open listens
        chanKemonoBody = llListen(8675309, "", llGetOwner(), "");
        chanKemonoHead = llListen(8675310, "", llGetOwner(), "");
        chanKemonoHeels = llListen(8675311, "", llGetOwner(), "");
        chanKemonoMaid = llListen(8675312, "", llGetOwner(), "");
        chanPonyAO = llListen(8675313, "", llGetOwner(), "");
        chanZeonWing = llListen(8675314, "", llGetOwner(), "");
        //send RLV scan requests
        llOwnerSay("@getinvworn:~HUD/Kemono.Body=8675309");
        llOwnerSay("@getinvworn:~HUD/Kemono.Head=8675310");
        llOwnerSay("@getinvworn:~HUD/Kemono.Heels=8675311");
        llOwnerSay("@getinvworn:~HUD/Kemono.Maid=8675312");
        llOwnerSay("@getinvworn:~HUD/Pony.AO=8675313");
        llOwnerSay("@getinvworn:~HUD/Zeon.Wing=8675314");
    }

    listen (integer channel, string name, key id, string message)
    {
        if (channel == 8675309)
        {
        	llListenRemove(chanKemonoBody);
            feedback++;
            if (message == "|10") statKemonoBody = "OFF";
            else statKemonoBody = "ON";
            if (feedback == 6) build_menu();
        }
        else if (channel == 8675310)
        {
        	llListenRemove(chanKemonoHead);
            feedback++;
            if (message == "|10") statKemonoHead = "OFF";
            else statKemonoHead = "ON";
            if (feedback == 6) build_menu();
        }
        else if (channel == 8675311)
        {
        	llListenRemove(chanKemonoHeels);
            feedback++;
            if (message == "|10") statKemonoHeels = "OFF";
            else if (message =="|20") statKemonoHeels = "PART ON";
            else statKemonoHeels = "ON";
            if (feedback == 6) build_menu();
        }
        else if (channel == 8675312)
        {
        	llListenRemove(chanKemonoMaid);
            feedback++;
            if (message == "|10") statKemonoMaid = "OFF";
            else statKemonoMaid = "ON";
            if (feedback == 6) build_menu();
        }
        else if (channel == 8675313)
        {
        	llListenRemove(chanPonyAO);
            feedback++;
            if (message == "|10") statPonyAO = "OFF";
            else statPonyAO = "ON";
            if (feedback == 6) build_menu();
        }
        else if (channel == 8675314)
        {
        	llListenRemove(chanZeonWing);
        	feedback++;
        	if (message == "|10") statZeonWing = "OFF";
        	else statZeonWing = "ON";
        	if (feedback == 6) build_menu();
        }
        else if (channel == chanDialog)
        {
        	llListenRemove(chanTrigger);
        	if (message == "KM Body" && statKemonoBody == "ON") llOwnerSay("@detach:~HUD/Kemono.Body=force");
        	else if (message == "KM Body" && statKemonoBody == "OFF") llOwnerSay("@attachallover:~HUD/Kemono.Body=force");
        	else if (message == "KM Head" && statKemonoHead == "ON") llOwnerSay("@detach:~HUD/Kemono.Head=force");
        	else if (message == "KM Head" && statKemonoHeels == "OFF") llOwnerSay("@attachallover:~HUD/Kemono.Head=force");
        	else if (message == "KM Heels" && statKemonoHeels == "ON") llOwnerSay("@detach:~HUD/Kemono.Heels=force");
        	else if (message == "KM Heels" && statKemonoHeels == "PART ON") llOwnerSay("@detach:~HUD/Kemono.Heels=force");
        	else if (message == "KM Heels" && statKemonoHeels == "OFF") llOwnerSay("@attachallover:~HUD/Kemono.Heels=force");
        	else if (message == "KM Maid" && statKemonoMaid == "ON") llOwnerSay("@detach:~HUD/Kemono.Maid=force");
        	else if (message == "KM Maid" && statKemonoMaid == "OFF") llOwnerSay("@attachallover:~HUD/Kemono.Maid=force");        	
        	else if (message == "Pony AO" && statPonyAO == "ON") llOwnerSay("@detach:~HUD/Pony.AO=force");
        	else if (message == "Pony AO" && statPonyAO == "OFF") llOwnerSay("@attachallover:~HUD/Pony.AO=force");
        	else if (message == "ZEON Wing" && statZeonWing == "ON") llOwnerSay("@detach:~HUD/Zeon.Wing=force");
        	else if (message == "ZEON Wing" && statZeonWing == "OFF") llOwnerSay("@attachallover:~HUD/Zeon.Wing=force");
        }
    }
}
