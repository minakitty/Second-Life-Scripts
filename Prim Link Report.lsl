// *********************************************************
// Prim Link Report v 0.2
// (c) 2017 Heather-Lynne Van Wilde
// Under the GNU Affero GPL, V 3.0, 19-Nov-2007
// https://www.gnu.org/licenses/agpl-3.0.en.html
//
// Script repository:
// https://github.com/minakitty/Second-Life-Scripts
//
// Self-deleting script that gives you the link number of a
// linked prim.  Good for identifying prim numbers for
// multiple llSetLinkColor calls
// *********************************************************

default
{
    state_entry()
    {
        llOwnerSay("Prim: "+(string)llGetLinkNumber());
        llRemoveInventory(llGetScriptName());
    }

    touch_start(integer total_number)
    {
       
    }
}
