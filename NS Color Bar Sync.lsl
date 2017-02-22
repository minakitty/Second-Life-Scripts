/* ********************************************************
   Nanite Systems Color Bar Sync v 1.2
   (c) 2017 Heather-Lynne Van Wilde
   Under the GNU Affero GPL, V 3.0, 19-Nov-2007
   https://www.gnu.org/licenses/agpl-3.0.en.html
  
   Script repository:
   https://github.com/minakitty/Second-Life-Scripts
  
   Nanite Systems controllers are able to output their light color using a 'light bus'.  This program is able to pick
   up that information and apply it to any prims/faces you choose, allowing you to color ears/wings/tails or whatever.
  
   NOTE: This system requires a Nanite Systems controller
   In-world location: http://maps.secondlife.com/secondlife/Eisa/64/55/26
   Marketplace: https://marketplace.secondlife.com/stores/175472
  
   Light bus channel calculations provided by NS Developers
   website: http://develop.nanite-systems.com/?light_bus
   *****************************************************
*/

/* Changelog
 1.2 - Introduced full prim/matrix programming, giving enhanced capabilities in future scripts
 1.1 - Corrected buggy parsing, added query on launch for initial color
 1.0 - Initial release
*/

/* 
Under normal circumstances, this is the only section you, as a user, should need to change.  We're going to create
a matrix of prims and faces that need to be colored based on the input from the controller.  In the first list, we
identify the exact prims that need to be recolored, and in the second list, we match the specific face that needs
to be colored.  There are a few caveats to this, however.

1) The number of items in the prims list MUST match the number of items in the faces list.  If they don't, the
script will error out.  If this happens, you'll get a warning, go back, update the script, then after saving set it
to "Running"
2) If multiple faces of a single prim need to be colored, you will need multiple entries form the prim.  For example:
prims = [1, 2, 2, 3]
faces = [0, 1, 3, 4]
would color face 0 of prim 1, faces 1 and 3 of prim 2, and face 4 of prim 3.
3) If an entire prim is to be colored, ALL_SIDES is accepted.  Since it's an integer shorthand, it's able to be added
without quotes, i.e. [3, 1, ALL_SIDES, 2] and the script will handle it just fine.

For more technical information:
llSetColor: http://wiki.secondlife.com/wiki/LlSetColor
If you need help identifying the prim number in a link (Firestorm's Build menu seems to fail at this), I have a tiny 
script that will report it's prim number, then self-delete here: 
https://raw.githubusercontent.com/minakitty/Second-Life-Scripts/master/Prim%20Link%20Report

*/
list prims = [2, 13, 14, 15, 16, 17, 18, 19];
list faces = [3,  2,  2,  2,  2,  2,  2,  2]; 


//The rest should not be changed under normal circumstances
integer channel_lights;
integer listener;
list rgb;
vector str;
integer i; 

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        llListenRemove(listener);
        if (llGetListLength(prims) != llGetListLength(faces)) //throw error if the prims and faces lists are not the same length, then pause script.  This will prevent the error mentioned in caveat 1 in the instrctions
        {
            llOwnerSay("There is a mismatch in the '" + llGetScriptName() + "' of this object.  The 'prims' list has " + (string)llGetListLength(prims) + " entries, while the 'faces' list has " + (string)llGetListLength(faces) + ".  Please update the variables, then restart the script to try again.");
            llSetScriptState(llGetScriptName(), FALSE);
        }
        channel_lights = -1 - (integer)("0x" + llGetSubString( (string) llGetOwner(), -7, -1) ) + 106;
        listener = llListen(channel_lights, "", NULL_KEY, ""); //listen on 'private key'
        llWhisper(channel_lights, "power-q");
    }
    
    listen (integer channel, string name, key id, string message)
    {
        //parse command from "color 0.000000 0.000000 0.000000" to RGB vector.  When done, then apply to prim.
        if (llGetSubString(message, 0, 4) == "color")
        {
            list rgb = llParseString2List(llGetSubString(message, 6, -1), [" "], []);
            str = <llList2Float(rgb, 0), llList2Float(rgb, 1), llList2Float(rgb, 2)>;
            for(i = 0; i < llGetListLength(prims); ++i)
                llSetLinkColor(llList2Integer(prims, i), str, llList2Integer(faces, i));
        }
    }
}
