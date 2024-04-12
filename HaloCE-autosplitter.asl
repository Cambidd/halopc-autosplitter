//Gearbox IL splitter

state ("halo") {}
state ("haloce") {}

init
{
    vars.watchers_h1 = new MemoryWatcherList();
    if (modules.First().ToString() == "halo.exe")
    {
        vars.watchers_h1 = new MemoryWatcherList() {
            (vars.H1_levelname = new StringWatcher(new DeepPointer(0x2A8174), 3)),
            (vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x2F1D8C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x29E8D8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_cinematic = new MemoryWatcher<bool>(new DeepPointer(0x3FFFD679)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_cutsceneskip = new MemoryWatcher<bool>(new DeepPointer(0x3FFFD67A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
        };
        
        vars.watchers_h1xy = new MemoryWatcherList() {
            (vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(0x2AC5BC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(0x2AC5C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
        };
        
        //scan for 00 00 80 3F 00 00 80 3F 00 00 80 3F 02 00 00 00 FF FF 00 during cryo cs. Last 7 values are these, in order.
        vars.watchers_h1fade = new MemoryWatcherList(){
            (vars.H1_fadetick = new MemoryWatcher<uint>(new DeepPointer(0x3FF15814)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
            (vars.H1_fadelength = new MemoryWatcher<ushort>(new DeepPointer(0x3FF15818)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_fadebyte = new MemoryWatcher<byte>(new DeepPointer(0x3FF1581A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
        };
    }
    else if (modules.First().ToString() == "haloce.exe")
    {
        vars.watchers_h1 = new MemoryWatcherList() {
            (vars.H1_levelname = new StringWatcher(new DeepPointer(0x243064), 3)),
            (vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x292E9C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x2397D0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_cinematic = new MemoryWatcher<bool>(new DeepPointer(0x3FFFD679)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_cutsceneskip = new MemoryWatcher<bool>(new DeepPointer(0x3FFFD67A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
        };
        
        vars.watchers_h1xy = new MemoryWatcherList() {
            (vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(0x2474EC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(0x2474F0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
        };
        
        //scan for 00 00 80 3F 00 00 80 3F 00 00 80 3F 02 00 00 00 FF FF 00 during cryo cs. Last 7 values are these, in order.
        vars.watchers_h1fade = new MemoryWatcherList(){
            (vars.H1_fadetick = new MemoryWatcher<uint>(new DeepPointer(0x3FF15814)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
            (vars.H1_fadelength = new MemoryWatcher<ushort>(new DeepPointer(0x3FF15818)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
            (vars.H1_fadebyte = new MemoryWatcher<byte>(new DeepPointer(0x3FF1581A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
        };
    }
}

startup
{
    print ("DO SOMETHING");

    vars.H1_levellist = new Dictionary<string, byte[]>{
        {"a10", new byte[] { 1, 2, 3, 4, 5, 6 }}, //poa
        {"a30", new byte[] { 1 }}, //halo
        {"a50", new byte[] { 1, 2, 3 }}, //tnr
        {"b30", new byte[] { 1 }}, //sc
        {"b40", new byte[] { 0, 1, 2, 4, 8, 9, 10, 11 }}, //aotcr - put the others in for fullpath andys
        {"c10", new byte[] { 1, 3, 4, 5 }}, //343
        {"c20", new byte[] { 1, 2, 3 }}, //library
        {"c40", new byte[] { 12, 10, 1, 9, 8, 6, 0, 5 }}, //tb
        {"d20", new byte[] { 4, 3, 2 }}, //keyes
        {"d40", new byte[] { 1, 2, 3, 4, 5, 6, 7 }}, //maw
    };

    settings.Add("ILmode", false, "Individual Level mode");
	settings.SetToolTip("ILmode", "Makes the timer start, reset and ending split at the correct IL time for each level.");

}

update
{
    vars.watchers_h1.UpdateAll(game);
}

start
{
    string checklevel = vars.H1_levelname.Current;

    if (vars.H1_levelname.Current == "a10" && vars.H1_bspstate.Current == 0 && vars.H1_tickcounter.Current > 280 && vars.H1_cinematic.Current == false && vars.H1_cinematic.Old == true) //Start on PoA
    {
        vars.watchers_h1xy.UpdateAll(game);
        if (vars.H1_xpos.Current < -55)
        {
            return true;
        }
    }
    else if ((settings["ILmode"]) && vars.H1_levelname.Current != "a10")	//Start on any level thats not PoA
    {

        switch (checklevel)
        {
            case "a30":
            if (((vars.H1_tickcounter.Current >= 182 && vars.H1_tickcounter.Current < 190) || (vars.H1_cinematic.Current == false && vars.H1_cinematic.Old == true && vars.H1_tickcounter.Current < 900)) && vars.H1_cutsceneskip.Current == false) //2 cases, depending on whether cs is skipped
            {
                return true;
            }
            break;

            case "a50":
            case "b30":
            case "b40":
            case "c10":
            if (vars.H1_tickcounter.Current > 30 && vars.H1_tickcounter.Current < 1060 && vars.H1_cinematic.Current == false && vars.H1_cinematic.Old == true) //levels with unskippable intro cutscenes
            {
                return true;
            }
            break;
            
            case "c20":
            case "c40":
            case "d20":
            case "d40":
            if (vars.H1_cutsceneskip.Current == false && vars.H1_cutsceneskip.Old == true) //levels with skippable intro cutscenes
            {
                return true;
            }
            break;				
        }
    } 
}

split
{
    string checklevel = vars.H1_levelname.Current;

    if (settings["ILmode"])
    {
        switch (checklevel)
        {
            case "a10":
            if (vars.H1_bspstate.Current == 6 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
            {
                return true;
            }
            break;
            
            case "a30": //so we don't false split on lightbridge cs
            if (vars.H1_bspstate.Current == 1 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
            {
                return true;
            }
            break;
            
            case "a50": //so we don't false split on prison or lift cs.
            if (vars.H1_bspstate.Current == 3 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
            {
                vars.watchers_h1fade.UpdateAll(game);
                if(vars.H1_fadelength.Current == 15)
                {
                    return true;
                }
            }
            break;
            
            case "b30": //no longer false splits on the security button
            if (vars.H1_bspstate.Current == 0 && vars.H1_cinematic.Current == false && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
            {
                return true;
            }
            break;
            
            case "b40": 
            if (vars.H1_bspstate.Current == 2 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true) //mandatory bsp load for any category
            {
                return true;
            }
            break;
            
            case "c10": //so we don't split on reveal cs
            if (vars.H1_bspstate.Current != 2 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
            {
                return true;
            }
            break;
            
            case "c20":
            if (vars.H1_cinematic.Current == true && vars.H1_cinematic.Old == false && vars.H1_tickcounter.Current > 30)
            {
                return true;
            }
            break;
            
            case "c40": //so dont false split on intro cutscene.
            if (vars.H1_tickcounter.Current > 30 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
            {
                vars.watchers_h1fade.UpdateAll(game); 
                if (vars.H1_fadebyte.Current != 1)	//so we dont false split on reverting to intro cutscene
                {
                    return true;
                }
            }
            break;
            
            case "d20": //keyes -- won't false split on fullpath
            vars.watchers_h1fade.UpdateAll(game);
            if (vars.H1_fadebyte.Current == 1)
            {
                if (vars.H1_fadelength.Current == 30 && vars.H1_tickcounter.Current >= (vars.H1_fadetick.Current + 28) && vars.H1_tickcounter.Old < (vars.H1_fadetick.Current + 28))
                {
                    return true;
                } else if (vars.H1_fadelength.Current == 60 && vars.H1_tickcounter.Current >= (vars.H1_fadetick.Current + 56) && vars.H1_tickcounter.Old < (vars.H1_fadetick.Current + 56)) //for the dumbass who does cutscene overlap. Nice timeloss :P
                {
                    return true;
                }
            }
            break;
            
            case "d40": //maw - will false split on bad ending but not bridge cs or death in end fadeout
            if (vars.H1_cinematic.Old == false && vars.H1_cinematic.Current == true && vars.H1_cutsceneskip.Current == false)
            {
                return true;
            }
            break;
            
            default: //don't need bsp check for levels without multiple cutscenes
            return false;
            break;
        }
    }
    else
    {
        if (vars.H1_levelname.Current != vars.H1_levelname.Old && vars.H1_levellist.ContainsKey(vars.H1_levelname.Current) && vars.H1_levellist.ContainsKey(vars.H1_levelname.Old))
        {
            return true;
        }
        else if (vars.H1_levelname.Current == "d40" && vars.H1_cinematic.Old == false && vars.H1_cinematic.Current == true && vars.H1_cutsceneskip.Current == false)
        {
            return true;
        }
    }
}

reset
{
    if (settings["ILmode"])
    {
        return (timer.CurrentPhase != TimerPhase.Ended &&( (
            (vars.H1_levelname.Current == "a10" && vars.H1_cutsceneskip.Current == true && vars.H1_tickcounter.Current < 30)
            || (vars.H1_levelname.Current == "a30" && vars.H1_cutsceneskip.Current == true && vars.H1_tickcounter.Current < 30) 
            || (vars.H1_levelname.Current == "a50" && vars.H1_tickcounter.Current < 500) 
            || (vars.H1_levelname.Current == "b30" && vars.H1_tickcounter.Current < 500) 
            || (vars.H1_levelname.Current == "b40" && vars.H1_tickcounter.Current < 500) 
            || (vars.H1_levelname.Current == "c10" && vars.H1_tickcounter.Current < 500) 
            || (vars.H1_levelname.Current == "c20" && vars.H1_cutsceneskip.Current == true && vars.H1_tickcounter.Current < 30)
            || (vars.H1_levelname.Current == "c40" && vars.H1_cutsceneskip.Current == true && vars.H1_tickcounter.Current < 30)
            || (vars.H1_levelname.Current == "d20" && vars.H1_cutsceneskip.Current == true && vars.H1_tickcounter.Current < 30)
            || (vars.H1_levelname.Current == "d40" && vars.H1_cutsceneskip.Current == true && vars.H1_tickcounter.Current < 30)
        ))); 
    }
    else return (vars.H1_levelname.Current == "a10" && vars.H1_cutsceneskip.Current == true && vars.H1_tickcounter.Current < 30);

}

isLoading
{
	return false;
}

gameTime
{
}