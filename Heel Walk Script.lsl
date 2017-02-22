// *********************************************************
// Heel Walk Script - v 1.0
// (c) 2017 Heather-Lynne Van Wilde
// Under the GNU Affero GPL, V 3.0, 19-Nov-2007
// https://www.gnu.org/licenses/agpl-3.0.en.html
//
// Script repository:
// https://github.com/minakitty/Second-Life-Scripts
//
// Script is designed to create a high heel 'cliking' 
// sound when walking and running.
// Simply place in any prim and it will auto-play sound.
// *********************************************************

// Play a sound whenever the owner is walking
string Sndwalk="555e954e-e112-0957-6327-1d945d729180";
string Sndrun="68a34894-49cd-21a3-fd87-89e501193f7b";
integer stop=1; //TRUE when not moving (priority 3)
integer walk=2; //TRUE when walking, running or crouch walking (priority 2)
integer run=3; //TRUE when running (priority 1)
integer oldStatus; //value remaining from last 
integer currentStatus; // 1 = Run, 2 = Walk, 3 = Stop

default
{
    state_entry()
    {
        // Start a timer to continuously check if the owner is walking
        llSetTimerEvent(0.25);
    }
    timer()
    {
        integer NowWalking = llGetAgentInfo(llGetOwner()) & AGENT_WALKING;
        integer NowRunning = llGetAgentInfo(llGetOwner()) & AGENT_ALWAYS_RUN;
        if (NowWalking & AGENT_WALKING) currentStatus = walk;
        if (NowRunning & AGENT_ALWAYS_RUN) currentStatus = run;
        if (!NowWalking) currentStatus = stop;
        if (oldStatus != currentStatus)
        {
            llStopSound();
            if (currentStatus == walk) llLoopSound(Sndwalk, 1.0);
            else if (currentStatus == run) llLoopSound(Sndrun, 1.0);
        }
        oldStatus = currentStatus;
    }
}
