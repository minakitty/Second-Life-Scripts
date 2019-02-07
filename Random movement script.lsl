
// *********************************************************
// Random movement script
// (c) 2019 Heather-Lynne Van Wilde
// Under the GNU Affero GPL, V 3.0, 19-Nov-2007
// https://www.gnu.org/licenses/agpl-3.0.en.html
//
// Script repository:
// https://github.com/minakitty/Second-Life-Scripts
//
// Randomizer for allowing objects to hover-move randomly
// around the user, with a rubber band type return if it
// gets too far from 'home'
// *********************************************************

// User defined variables
float max_wander = 3; //the maximum distance (meters) the object can move from home (set in the Build menu)
float rubber_band = .25; //how much should the object rubber band if it hits max wander (0 = 0%, 1 = 100%, default .25 = 25%)


vector home;
vector current;
integer rnd_direction;
float distance;

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        home = llGetLocalPos();
        current = home;
        state decision;
    }
}
state decision
{
    state_entry() // if object is too far from home, apply rubber band and move, otherwise, roll 'dice'
    {
        if (llVecDist(home, current) >= max_wander)
        {
            current = current * rubber_band; //apply the rubber band percentage
            state movement;
        }
        else
        {
            rnd_direction = (integer)(llFrand(7.0));
            state randomizer;
        }
    }
}

state randomizer
{
    state_entry()
    {
        if (rnd_direction == 1) current = current + <0.01,0.0,0.0>;
        else if (rnd_direction == 2) current = current + <0.0,0.01,0.0>;
        else if (rnd_direction == 3) current = current + <0.0,0.0,0.01>;
        else if (rnd_direction == 4) current = current + <-0.01,0.0,0.0>;
        else if (rnd_direction == 5) current = current + <0.0,-0.01,0.0>;
        else if (rnd_direction == 6) current = current + <0.0,0.0,-0.01>;

        state movement;
    }
}

state movement
{
    state_entry()
    {
        llSetPos(current);
        state decision;
    }
}