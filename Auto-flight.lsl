// *********************************************************
// Auto-Flight Script
// (c) 2017 Heather-Lynne Van Wilde
// Under the GNU Affero GPL, V 3.0, 19-Nov-2007
// https://www.gnu.org/licenses/agpl-3.0.en.html
//
// Script repository:
// https://github.com/minakitty/Second-Life-Scripts
//
// Script sends triggers to delpoy or put away wings/boosters
// when you fly or stop flying
// Simply place in any object other than one of the wings and set values
// *********************************************************

// User defined variables
string open="open"; //code to open wings
string close="close"; //code to close wings
integer chan=-123456; //channel to send triggers on



integer oldStatus; 


default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        oldStatus = FALSE; //start closed
        llWhisper(chan, close); //make sure wings are closed.  Will reopen if script started while flying
        // Start a timer to continuously check if the owner is flying
        llSetTimerEvent(0.25);
    }
    timer()
    {
        integer NowFlying = llGetAgentInfo(llGetOwner()) & AGENT_FLYING;
        if (oldStatus != NowFlying)
        {
            if (NowFlying == TRUE) llWhisper(chan, open);
            else if (NowFlying == FALSE) llWhisper(chan, close);
        }
        oldStatus = NowFlying;
    }
}
