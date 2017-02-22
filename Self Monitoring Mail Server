// *********************************************************
// Self-monitoring mail server
// (c) 2010 Heather-Lynne Van Wilde
// Under the GNU Affero GPL, V 3.0, 19-Nov-2007
// https://www.gnu.org/licenses/agpl-3.0.en.html
//
// Script repository:
// https://github.com/minakitty/Second-Life-Scripts
//
// This was designed to be a single use outgoing mailbox that
// could send a single item to a user at a predefined time
// period after setup.  Was not intended for use of griefing
// or creating drama (although Dear John letters would be a
// more common use.)  Code is likely very dirty, and the
// flow pattern for the listen is reversed on purpose 
// (to prevent the script jumping ahead of itself on the step
// counter.)
// *********************************************************

key avatar;
string mail;
integer hours;
integer minutes;
integer step;
string avatar_name;
float temp;
string online;
default
{
    state_entry()
    {
        step = 0;
        llListen (0, "", llGetOwner(), ""); //ready to ask keys
        llWhisper(0, "State the key of the Avatar you want to send mail to");
    }
    listen(integer channel, string name, key id, string message)
    {
        if (llToLower(message) == "quit")
        {
            llWhisper(0, "Processing quit");
            llDie();
        }
        if (step == 4) //Set up mail
        {
            if (llToLower(message) == "yes")
            {
                llWhisper(0, "Preparing to mail package when timer runs out.  Have a nice day!");
                llSetTimerEvent(60.0);
                llRequestAgentData((key)avatar, DATA_ONLINE);
            }
            if (llToLower(message) == "no")
            {
                llWhisper(0, "Restarting mail process");
                step = 0;
                llWhisper(0, "State the key of the Avatar you want to send mail to");
            }
        }
        if (step == 3) //Calculate hours
        {
            llWhisper(0, "You entered " + message + " minutes.  Calculating:");
            temp = (integer)message / 60; //decimal hours
            minutes = (integer)message;
            hours = (integer)temp;
            minutes = minutes - (hours*60);
            llWhisper(0, "Timer set for " + (string)hours + ":" + (string)minutes);
            llWhisper(0, "I need to know if this package is ready to be mailed.  Please answer 'Yes' or 'No'");
            step = 4;
        }
        else if (step == 2) //Check mailability of item   
        {
            mail = message;
            llWhisper(0, "Applying postage.  Enter minutes until mailing.  Remember 1 hr = 60 min, 5 hr = 300 min.  Make sure to use arabic numbers.");
            step = 3;
        }
        else if (step == 1) //get mail info
        {
            if (llToLower(message) == "no")
            {
                step = 0;
                llWhisper(0, "State the key of the Avatar you want to send mail to"); 
            }
            else if(llToLower(message) == "yes")
            {
                llWhisper(0, "Make sure the item you wish to mail has the Transfer option enabled and enter the name of the item in chat now");
                step = 2;
            }
        }
        if (step == 0) // Asking for recipient key
        {
            avatar = message;
            llWhisper(0, "Attempting to validate key");
            llRequestAgentData((key)avatar, DATA_NAME);
            step = 1;
        }
    }
    dataserver(key queryid, string data) 
    {
        if (step == 1)
        {
            llWhisper(0, "Information returned");
            avatar_name = data;
            llWhisper(0, "Validating information:");
            llWhisper(0, "Key supplied: " + (string)avatar);
            llWhisper(0, "Avatar Name: " + avatar_name);
            llWhisper(0, "Is this correct?  Please enter 'Yes' or 'No' now.");
        }
        if (step == 4)
        {
            online = "offline";
            if (data = (string)TRUE)
            {
                online = "online";
            }
            llSetText("Mail Prepped \nMail to " + avatar_name + " who is " + online + "\nMailing in " + (string)hours + ":" + (string)minutes, <1.0,0.0,0.0>, 1.0);
        }
    }
    timer()
    {
        if (minutes == 0)
        {
            if (hours == 0)
            {
                //send mail
                llInstantMessage((key)avatar, "You have incoming mail!  Please stand by.");
                llGiveInventory((key)avatar, mail);
                llInstantMessage(llGetOwner(), "Mail service requested for " + avatar_name + " is completed.  Mailbox is going offline now");
                llDie();
            }
            hours = hours - 1;
            minutes = 60;
        }
        minutes = minutes - 1;
        llRequestAgentData((key)avatar, DATA_ONLINE);
    }
        on_rez(integer start_param)
    {
        llResetScript();
    }
}
