/* ********************************************************
   Self Titler and Chat Redirect v 1.0
   (c) 2017 Heather-Lynne Van Wilde
   Under the GNU Affero GPL, V 3.0, 19-Nov-2007
   https://www.gnu.org/licenses/agpl-3.0.en.html
  
   Script repository:
   https://github.com/minakitty/Second-Life-Scripts
  
   A combination titler and chat redirect.  Allows for an
   all-in-one RP information system.  Rezzes in a locked
   and activated position.  Click on it to toggle the
   lock+active status
  
   Requires an RLV/RLVa capable viewer that supports 
   @redirchat and @rediremote functions (version 1.19)
   *****************************************************
*/

/* Changelog
 1.0 - Initial release
*/

/* 
Script notes
1) LSL scripts use '\n' as a new line escape character.  So to create a multi-line titler like:

Joey McNormalperson
Level 1 Noob

you would use the following value "Joey McNormalperson\nLevel 1 Noob"

2) For help choosing a color for the titler_color value, please use the tool at this website: https://www.outworldz.com/colorpicker/
*/

//titler variables
string titler_name = "Enter Titler\nhere";
vector titler_color = <1.0,1.0,1.0>;
float titler_alpha = 1.0; //1.0 is full color, 0.0 is fully transparent

//chat redirect variables
string chat_name = "Your name here";
integer chat_listen = 8675309; //redirect channel for chat redirect
integer listener;



default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    attach(key id)
    {
        if (id)
        {

        }
        else
        {
            llOwnerSay("Shutting Down");
            llSetObjectName("AT Chat Titler");
            llOwnerSay("@clear");
         }

    }

        state_entry()
    {
        llSetText(titler_name, titler_color, titler_alpha);
        llSetObjectName(chat_name);
        llOwnerSay("@redirchat:8675309=add,rediremote:8675309=add");
        listener = llListen(chat_listen, "", llGetOwner(), "");
        llOwnerSay("Chat Titler Online");
    }

    listen (integer channel, string name, key id, string message)
    {
        llSay(0, message);
    }
}
