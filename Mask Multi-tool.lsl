// *********************************************************
// Mask Multi-tool script
// (c) 2020 Heather-Lynne Van Wilde
// Under the GNU Affero GPL, V 3.0, 19-Nov-2007
// https://www.gnu.org/licenses/agpl-3.0.en.html
//
// Script repository:
// https://github.com/minakitty/Second-Life-Scripts
//
// Multi-purpose mask controller, with integrated gag,
// public control, chat renamer and vision/hearing blocker
//
// Text replacer algorithm built on top of the gag garbler
// in the old Dari Haus gags that were released to the 
// public by Lara Benedict (but with revamped
// implementation)
// *********************************************************

//To-do list
//Private

// Variables
integer gRLVa; //Get RLVa validation (will be implemented when RLVa functions are added.  Minimum version needed v2.9)
integer gRename; //Boolean for gag/renamer, defaults to 0 (0 = rename only, 1 = loose muffle, 2 = moderate muffle, 3 = severe muffle)
string sRename;    //Will pull renamer name from mask description when activated

integer gLenses; //Boolean for lens, defaults to 0 (0 = clear, 1 = mirrored, 2 = opaque/blind)

integer gHearing;

integer gLock; //Boolean for lock, defaults to FALSE

integer gPrivate; //Boolean for public access, defaults to TRUE (no public access)

integer access_granted; //security check

//llListen triggers
integer listener;
integer ver_listener;
integer chanTrigger;

//variables for building touch menu
string statGag;
string statVision;
string statHearing;
string statLock;
string statPrivate;
string dialogStat;
list dialogGrid = ["Lock", "Private", "Reset", "Gag", "Vision", "Hearing"];
integer chanDialog;

//variables for processing gag speech
string speechOrigin;
string speechPost;
integer procPause; //don't process if emote
integer i;
string speechProc;
string rep;



default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        //Set all variables to default
        gRename = 0;
        sRename = llGetObjectDesc();
        gLenses = 0;
        llSetAlpha(0.1, 1); //set lens to clear
        // To-do, set blindness off
        gLock = FALSE;
        gPrivate = TRUE; 
        gHearing = TRUE;
        //RLVa version checking
        ver_listener = llListen(18675309, "", llGetOwner(), "");
        llOwnerSay("@versionnum=18675309");
        llSetTimerEvent(10.0); //crash timer
    }

    listen (integer channel, string name, key id, string message)
    {
        if (channel == 18675309) //RLVa API check
        {
            if ((integer)message >= 2900000) //RLVa API succeeds
            {
                gRLVa = TRUE;
                llSetTimerEvent(0.0); //Kill the timeout
                llOwnerSay("@clear");
                llOwnerSay("@redirchat:8675309=add,rediremote:8675309=add"); //capture all chat and emotes to send to voice processing
                listener = llListen(8675309, "", llGetOwner(), "");
                llSetObjectName(sRename);
                llListenRemove(ver_listener);
                chanDialog = 28675309;
                chanTrigger = llListen(chanDialog, "", llGetOwner(), "");
            }
        }

        else if (channel == 28675309) //llDialog processing
        {
            if (message =="Gag")
            {
                gRename++;
                   if (gRename == 4) gRename = 0; //if Gag was level 3, remove gag
            }
            else if (message == "Vision")
            {
            	gLenses++;
            		if (gLenses == 3) gLenses = 0; //if vision was already blocked, clear all
            	if (gLenses == 0)
            	{
            		llSetAlpha(0.1, 1);
            		//llOwnerSay("@camdrawmin:0.5=n,camdrawmax:3.0=n,camunlock=y,camavdist:1.0=y,showworldmap=y,showminimap=y,showloc=y,shownametags=y,showhovertextworld=y"); //shut down pending Firestorm updating API
            		//version 1.16 compatable alternative
            		llOwnerSay("@setdebug_renderresolutiondivisor:1=force,showworldmap=y,showminimap=y,showloc=y,shownametags=y,showhovertextworld=y");
            	}
            	else if (gLenses == 1)
            	{
            		llSetAlpha(1.0, 1);
            	}
            	else
            	{
            		//llOwnerSay("@camdrawmin:0.5=y,camdrawmax:3.0=y,camunlock=n,camavdist:1.0=n,showworldmap=n,showminimap=n,showloc=n,shownametags=n,showhovertextworld=n"); //shut down pending Firestorm updating API
            		//version 1.16 compatable alternative
            		llOwnerSay("@setdebug_renderresolutiondivisor:64=force,showworldmap=n,showminimap=n,showloc=n,shownametags=n,showhovertextworld=n");
            	}
            }
            else if (message == "Hearing")
            	if (gHearing == TRUE)
            	{
            		gHearing = FALSE;
            		llOwnerSay("@recvchat_sec=n,recvemote_sec=n");
            	}
            	else
            	{
            		gHearing = TRUE;
            		llOwnerSay("@recvchat_sec=y,recvemote_sec=y");
            	}
            else if (message == "Lock")
            {
            	if (gLock == FALSE)
            	{
            		gLock = TRUE; //set TRUE
            		llPlaySound("d9246d94-e26c-c848-4647-e504e8bc115c", 1.0);
            		llOwnerSay("@detach=n");
            	}
            	else
            	{
            		gLock = FALSE;
            		llPlaySound("8a7f31d5-01ee-45eb-4a55-e536b5151c5c", 1.0);
            		llOwnerSay("@detach=y");
            	}
            }
            else if (message == "Private") 
            {
            	if (gPrivate == TRUE) gPrivate = FALSE;
            	else gPrivate = TRUE;
            }
            else if (message == "Reset")
            {
                llOwnerSay("@clear");
                llResetScript();
            }
            if (gRename == 0) statGag = " ⊠  Not Gagged";
		    else if (gRename == 1) statGag = "▁   Loose Gag";
		    else if (gRename == 2) statGag = "▁▅  Snug Gag";
		    else statGag = "▁▅▉ Tight Gag";

		    if (gLenses == 0) statVision = "Unimpeded";
		    else if (gLenses == 1) statVision = "Mirrored Lens";
		    else statVision = "Blinding Lens";

		    if (gHearing == TRUE) statHearing = "Full Hearing";
		    else statHearing = "Deaf";

		    if (gLock == FALSE) statLock = "Unlocked";
		    else statLock = "Locked";

		    if (gPrivate == FALSE) statPrivate = "Open to Public";
		    else statPrivate = "Restricted to Wearer";

		    dialogStat = "Current HUD status:\n Gag: " + statGag + "\n Vision: " + statVision + "\n Hearing: " + statHearing + "\n Lock: " + statLock + "\n Access: " + statPrivate;
		    llDialog(llDetectedKey(0), dialogStat, dialogGrid, chanDialog);
        }

        else if (channel == 8675309) //Chat processing
        {
            if (gRename == 0) llSay(0, message); //renamer only, ignore mumbler for speed
            else
            {
                speechOrigin = message;
                speechPost = "";
                if (llGetSubString(speechOrigin, 0, 2) == "/me") 
                {
                	procPause = TRUE; //is emote, start proc paused
                }
                else 
                {
                	procPause = FALSE;
                }

                for (i = 0; i < llStringLength(speechOrigin); i++)
                {
                    speechProc = llGetSubString(speechOrigin, i, i);
                    rep = "";
                    if (procPause == FALSE)
                    {
                        if (speechProc == "\"")
                        {
                            procPause = TRUE;
                            speechPost = speechPost + speechProc;
                        }
                        else if (gRename == 1)
                        {
	                        if (speechProc == "l")
	                            rep = "w";
	                        else
	                        if (speechProc == "L")
	                            rep = "W";
	                        else
	                        if (speechProc == "s")
	                            rep = "f";
	                        else
	                        if (speechProc == "S")
	                            rep = "F";
	                        else
	                        if (speechProc == "t")
	                            rep = "g";               
	                        else
	                        if (speechProc == "T")
	                            rep = "G";                
                        }
                        else if (gRename == 2)
                        {
	                        if (speechProc == "r" || speechProc == "l" || speechProc == "q" || speechProc == "j" || speechProc == "d")
	                            rep = "w";
	                        else
	                        if (speechProc == "R" || speechProc == "L" || speechProc == "Q" || speechProc == "J" || speechProc == "D")
	                            rep = "W";
	                        else
	                        if (speechProc == "s")
	                            rep = "f";
	                        else
	                        if (speechProc == "S")
	                            rep = "F";
	                        else
	                        if (speechProc == "b" | speechProc == "t")            
	                            rep = "g";            
	                        else
	                        if (speechProc == "B" | speechProc == "T")
	                            rep = "G";
                        }
                        else if (gRename == 3)
                        {
	                        if (speechProc == "r" || speechProc == "l" || speechProc == "q" || speechProc == "j" || speechProc == "d")
	                            rep = "w";
	                        else
	                        if (speechProc == "R" || speechProc == "L" || speechProc == "Q" || speechProc == "J" || speechProc == "D")
	                            rep = "W";
	                        else
	                        if (speechProc == "s")
	                            rep = "f";
	                        else
	                        if (speechProc == "S")
	                            rep = "F";
	                        else
	                        if (speechProc == "b" | speechProc == "t" | speechProc == "h" | speechProc == "d" | speechProc == "c" | speechProc == "k" | speechProc == "v")            
	                            rep = "g";            
	                        else
	                        if (speechProc == "B" | speechProc == "T" | speechProc == "H" | speechProc == "D" | speechProc == "C" | speechProc == "K" | speechProc == "V")
	                            rep = "G";
                        }

                        if (rep != "") speechProc = rep;//text was changed
                    }
                    //meanwhile if procPause was true
                    else if (procPause == TRUE)
                    {
                        if (speechProc == "\"") procPause = FALSE;
                    }
                    speechPost = speechPost + speechProc;
                }
                if (gRename ==3) llWhisper(0, speechPost);
                else llSay(0, speechPost);
            }
        }
    }

    timer()
    {
        //This should never be called unless the RLVa Version checker timed out, meaning those functions fail
        llOwnerSay("Uh oh, either you don't have RLVa enabled or something horrible went wrong.  I'd suggest making sure it's turned on and then clicking the 'Reset' option in the menu.");
        gRLVa = FALSE;
        llSetTimerEvent(0.0);
        llListenRemove(ver_listener);
    }

    touch_start(integer total_number)
    {
    	access_granted = FALSE;
    	if (gPrivate == TRUE && llDetectedKey(0) == llGetOwner()) access_granted = TRUE; // Private access and proper user
    	else if (gPrivate == FALSE) access_granted = TRUE;

    	if (access_granted == TRUE)
    	{
	        if (gRename == 0) statGag = " ⊠  Not Gagged";
		    else if (gRename == 1) statGag = "▁   Loose Gag";
		    else if (gRename == 2) statGag = "▁▅  Snug Gag";
		    else statGag = "▁▅▉ Tight Gag";

		    if (gLenses == 0) statVision = "Unimpeded";
		    else if (gLenses == 1) statVision = "Mirrored Lens";
		    else statVision = "Blinding Lens";

		    if (gHearing == TRUE) statHearing = "Full Hearing";
		    else statHearing = "Deaf";

		    if (gLock == FALSE) statLock = "Unlocked";
		    else statLock = "Locked";

		    if (gPrivate == FALSE) statPrivate = "Open to Public";
		    else statPrivate = "Restricted to Wearer";

		    dialogStat = "Current HUD status:\n Gag: " + statGag + "\n Vision: " + statVision + "\n Hearing: " + statHearing + "\n Lock: " + statLock + "\n Access: " + statPrivate;
		    llDialog(llDetectedKey(0), dialogStat, dialogGrid, chanDialog); 
		}
   }
}