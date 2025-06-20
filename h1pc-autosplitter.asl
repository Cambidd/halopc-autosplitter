// Halo PC (2003) Autosplitter
// Supports Custom Edition with base campaign maps
// Game must be updated to 1.0.10

// FEATUES
/* 
    - Basic start, split and reset for fullgame and individual level speedruns
    - BSP (loading... done) splitting
    - Custom IL splits (WIP)
    - Start timer on any level mode (useful for Hunter% type meme runs)
    - Death counter
 */

state ("halo") {}
state ("haloce") {}

init {
    vars.watchers_h1 = new MemoryWatcherList();
    vars.watchers_h1xy = new MemoryWatcherList();
    vars.watchers_h1fade = new MemoryWatcherList();
    vars.watchers_a50 = new MemoryWatcherList();
    vars.watchers_b30 = new MemoryWatcherList();
    vars.watchers_c40 = new MemoryWatcherList();

    if (modules.First().ToString() == "halo.exe") {
        version = "Retail";

        vars.H1_map_globals = 0x319738;
        vars.H1_map = 0x2A8154;
        vars.H1_cinflags = 0x2F187C;
        vars.H1_coords = 0x2AC5BC;
        vars.H1_fade = 0x2F1884;
        vars.H1_hsthread = 0x47A470;

        vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(0x2F1D8C)) { Name = "tickcounter" });
        vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(0x29E8D8)) { Name = "bspstate" });
        vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(0x2E2DEC, 0x126)) { Name = "difficulty" });

        vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.H1_map + 0x20), 32) { Name = "levelname" });
        vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.H1_map + 0x40), 32) { Name = "buildversion" });

        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_map_globals)) { Name = "mapreset" });
        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_map_globals + 0x1)) { Name = "gamewon" });
        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_cinflags, 0x8)) { Name = "cinematic" });
        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_cinflags, 0x9)) { Name = "cutsceneskip" });
        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_map_globals + 0x17)) { Name = "deathflag" });

        vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.H1_coords)) { Name = "xpos" });
        vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.H1_coords + 0x4)) { Name = "ypos" });
        vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.H1_coords + 0x8)) { Name = "zpos" });
        vars.watchers_h1xy.Add(new MemoryWatcher<byte>(new DeepPointer(vars.H1_coords - 0x8)) { Name = "chiefstate" });

        vars.watchers_h1fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.H1_fade, 0xF8)) { Name = "fadetick" });
        vars.watchers_h1fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.H1_fade, 0xFC)) { Name = "fadelength" });
        vars.watchers_h1fade.Add(new MemoryWatcher<byte>(new DeepPointer(vars.H1_fade, 0xFE)) { Name = "fadebyte" });

        vars.watchers_c40.Add(new MemoryWatcher<byte>(new DeepPointer(0x4603B0, 0x868, 0x1F4)) { Name = "door3state" });
        vars.watchers_c40.Add(new MemoryWatcher<float>(new DeepPointer(0x4603B0, 0x730, 0x124)) { Name = "liftstate" });
        vars.watchers_c40.Add(new MemoryWatcher<float>(new DeepPointer(0x47ABF0, 0x94)) { Name = "brokendoorstate" });
        vars.watchers_c40.Add(new MemoryWatcher<float>(new DeepPointer(0x47ABF0, 0xA4)) { Name = "lastdoorstate" });

    }

    else if (modules.First().ToString() == "haloce.exe") {
        version = "Custom Edition";

        vars.H1_map_globals = 0x2B47C8;
        vars.H1_map = 0x243044;
        vars.H1_cinflags = 0x28C83C;
        vars.H1_coords = 0x2474EC;
        vars.H1_fade = 0x28C844;
        vars.H1_hsthread = 0x415910;

        vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(0x292E9C)) { Name = "tickcounter" });
        vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(0x2397D0)) { Name = "bspstate" });
        vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(0x27DDAC, 0x126)) { Name = "difficulty" });

        vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.H1_map + 0x20), 32) { Name = "levelname" });
        vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.H1_map + 0x40), 32) { Name = "buildversion" });

        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_map_globals)) { Name = "mapreset" });
        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_map_globals + 0x1)) { Name = "gamewon" });
        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_cinflags, 0x8)) { Name = "cinematic" });
        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_cinflags, 0x9)) { Name = "cutsceneskip" });
        vars.watchers_h1.Add(new MemoryWatcher<bool>(new DeepPointer(vars.H1_map_globals + 0x17)) { Name = "deathflag" });

        vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.H1_coords)) { Name = "xpos" });
        vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.H1_coords + 0x4)) { Name = "ypos" });
        vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.H1_coords + 0x8)) { Name = "zpos" });
        vars.watchers_h1xy.Add(new MemoryWatcher<byte>(new DeepPointer(vars.H1_coords - 0x8)) { Name = "chiefstate" });

        vars.watchers_h1fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.H1_fade, 0xF8)) { Name = "fadetick" });
        vars.watchers_h1fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.H1_fade, 0xFC)) { Name = "fadelength" });
        vars.watchers_h1fade.Add(new MemoryWatcher<byte>(new DeepPointer(vars.H1_fade, 0xFE)) { Name = "fadebyte" });

        vars.watchers_c40.Add(new MemoryWatcher<byte>(new DeepPointer(0x3FB710, 0x868, 0x1F4)) { Name = "door3state" });
        vars.watchers_c40.Add(new MemoryWatcher<float>(new DeepPointer(0x3FB710, 0x730, 0x124)) { Name = "liftstate" });
        vars.watchers_c40.Add(new MemoryWatcher<float>(new DeepPointer(0x416110, 0x94)) { Name = "brokendoorstate" });
        vars.watchers_c40.Add(new MemoryWatcher<float>(new DeepPointer(0x416110, 0xA4)) { Name = "lastdoorstate" });

    }

    vars.watchers_a50.Add(new MemoryWatcher<uint>(new DeepPointer(vars.H1_hsthread, 0x9734)) { Name = "dropship" });

    vars.watchers_b30.Add(new MemoryWatcher<uint>(new DeepPointer(vars.H1_hsthread, 0xAEC)) { Name = "pelican" });

    vars.watchers_c40.Add(new MemoryWatcher<byte>(new DeepPointer(vars.H1_hsthread, 0x8CDA)) { Name = "gen1state" });
}

startup {
    // START AND END CONDITIONS
    vars.H1_ILstart = new Dictionary<string, Func<bool>> {
        {"a10", () => vars.watchers_h1["bspstate"].Current == 0 && vars.watchers_h1xy["xpos"].Current < -55 && vars.watchers_h1["tickcounter"].Current > 280 && !vars.watchers_h1["cinematic"].Current && vars.watchers_h1["cinematic"].Old }, //poa
        {"a30", () => ((vars.watchers_h1["tickcounter"].Current >= 182 && vars.watchers_h1["tickcounter"].Current < 190) || (!vars.watchers_h1["cinematic"].Current && vars.watchers_h1["cinematic"].Old && vars.watchers_h1["tickcounter"].Current > 500 && vars.watchers_h1["tickcounter"].Current < 900)) && !vars.watchers_h1["cutsceneskip"].Current }, //halo
        {"a50", () => vars.watchers_h1["tickcounter"].Current > 30 && vars.watchers_h1["tickcounter"].Current < 900 && !vars.watchers_h1["cinematic"].Current && vars.watchers_h1["cinematic"].Old }, //tnr
        {"b30", () => vars.watchers_h1["tickcounter"].Current > 30 && vars.watchers_h1["tickcounter"].Current < 1060 && !vars.watchers_h1["cinematic"].Current && vars.watchers_h1["cinematic"].Old }, //sc
        {"b40", () => vars.watchers_h1["tickcounter"].Current > 30 && vars.watchers_h1["tickcounter"].Current < 950 && !vars.watchers_h1["cinematic"].Current && vars.watchers_h1["cinematic"].Old }, //aotcr
        {"c10", () => vars.watchers_h1["tickcounter"].Current > 30 && vars.watchers_h1["tickcounter"].Current < 700 && !vars.watchers_h1["cinematic"].Current && vars.watchers_h1["cinematic"].Old }, //343
        {"c20", () => !vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1["cutsceneskip"].Old }, //library
        {"c40", () => !vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1["cutsceneskip"].Old }, //tb
        {"d20", () => !vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1["cutsceneskip"].Old }, //keyes
        {"d40", () => !vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1["cutsceneskip"].Old }, //maw
    };

    vars.H1_customstart = new Dictionary<string, Func<bool>> {
        {"lumoria_a", () => (vars.watchers_h1["tickcounter"].Current >= 686 && vars.watchers_h1["tickcounter"].Current < 690 && !vars.watchers_h1["cutsceneskip"].Current)},
    };

    vars.H1_ILendsplits = new Dictionary<string, Func<bool>> {
        {"a10", () => vars.watchers_h1["bspstate"].Current == 6 && !vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["cutsceneskip"].Current }, //poa
        {"a30", () => vars.watchers_h1["bspstate"].Current == 1 && !vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["cutsceneskip"].Current }, //halo
        {"a50", () => (vars.watchers_h1["bspstate"].Current == 3 || vars.watchers_h1["bspstate"].Current == 2) && !vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1fade["fadelength"].Current == 15 }, //tnr
        {"b30", () => vars.watchers_h1["bspstate"].Current == 0 && !vars.watchers_h1["cinematic"].Current && !vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["cutsceneskip"].Current }, //sc
        {"b40", () => vars.watchers_h1["bspstate"].Current == 2 && !vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["cutsceneskip"].Current }, //aotcr
        {"c10", () => vars.watchers_h1["bspstate"].Current != 2 && !vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["cutsceneskip"].Current }, //343
        {"c20", () => vars.watchers_h1["cinematic"].Current && !vars.watchers_h1["cinematic"].Old && vars.watchers_h1["tickcounter"].Current > 30 }, //library
        {"c40", () => vars.watchers_h1["tickcounter"].Current > 30 && !vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1fade["fadebyte"].Current != 1 }, //tb
        {"d20", () => vars.watchers_h1fade["fadelength"].Current == 30 && !vars.watchers_h1["cinematic"].Old && vars.watchers_h1["cinematic"].Current}, //keyes
        {"d40", () => !vars.watchers_h1["cinematic"].Old && vars.watchers_h1["cinematic"].Current && !vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1xy["xpos"].Current > 1000 && !vars.watchers_h1["deathflag"].Current}, //maw
    };


    // IL SPLITS
    vars.H1_a10splits = new Dictionary<byte, Func<bool>> {
        {0, () => !vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["bspstate"].Current == 1}, //Split on bridge cs
        {1, () => vars.watchers_h1["bspstate"].Current == 2 && vars.watchers_h1["bspstate"].Old != 2}, //Split on bsp switch after cafe
        {2, () => vars.watchers_h1["bspstate"].Current == 2 && vars.watchers_h1xy["xpos"].Current < -44 && vars.watchers_h1xy["ypos"].Current > 20}, //Split on approaching flank encounter
        {3, () => vars.watchers_h1["bspstate"].Current == 3 && vars.watchers_h1["bspstate"].Old != 3}, //Split on load before loop encounter
        {4, () => vars.watchers_h1["bspstate"].Current == 4 && vars.watchers_h1["bspstate"].Old != 4}, //Split on load before stair encounter
        {5, () => vars.watchers_h1["bspstate"].Current == 4 && vars.watchers_h1xy["xpos"].Current < -60 && !(vars.watchers_h1xy["xpos"].Old < -60) && vars.watchers_h1xy["ypos"].Current < 34}, //Split on entering maintenance tunnel
        {6, () => vars.watchers_h1["bspstate"].Current == 6 && vars.watchers_h1["bspstate"].Old != 6}, //Split on last load
    };

    vars.H1_a50splits = new Dictionary<byte, Func<bool>> {
        {0, () => vars.watchers_a50["dropship"].Changed && vars.watchers_a50["dropship"].Current != 0 && vars.watchers_a50["dropship"].Old != 0 && vars.watchers_h1["difficulty"].Current == 3}, //Split on c ship spawn (on leg)
        {1, () => vars.watchers_h1["bspstate"].Current == 1 && vars.watchers_h1["bspstate"].Old != 1}, //Split on belly
        {2, () => vars.watchers_h1xy["ypos"].Current < -24 && vars.watchers_h1["bspstate"].Current == 2}, //Split on entering hangar
        {3, () => vars.watchers_h1["bspstate"].Current == 3 && vars.watchers_h1["bspstate"].Old != 3}, //Split on bridge bsp
        {4, () => vars.watchers_h1xy["xpos"].Current < -6.1 && vars.watchers_h1["bspstate"].Current == 3}, //Split on bridge exit
        {5, () => !vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["bspstate"].Current == 3}, //Split on prison cs
    };

    vars.H1_b30splits = new Dictionary<byte, Func<bool>> {
        {0, () => vars.watchers_h1xy["chiefstate"].Current == 2 && vars.watchers_h1["tickcounter"].Current > 1100}, //Split on entering hog
        {1, () => (vars.watchers_h1xy["ypos"].Current < -23.3 && vars.watchers_h1xy["xpos"].Current < 3.7) || (vars.watchers_h1["bspstate"].Current == 1 && vars.watchers_h1xy["zpos"].Current < 2.0 )}, //Split on fling
        {2, () => !vars.watchers_h1["cutsceneskip"].Current && vars.watchers_h1["cutsceneskip"].Old && vars.watchers_h1["bspstate"].Current == 1}, //Split on button
        {3, () => vars.watchers_b30["pelican"].Changed && vars.watchers_b30["pelican"].Current != 0 && vars.watchers_b30["pelican"].Old != 0}, //Split on pelican spawn
    };

    vars.H1_c40splits = new Dictionary<byte, Func<bool>> {
        {0, () => vars.watchers_c40["door3state"].Current == 4 && vars.watchers_c40["door3state"].Old == 0}, //Split on ext door button
        {1, () => vars.watchers_h1xy["chiefstate"].Current == 2 && vars.watchers_h1xy["chiefstate"].Old != 2 && vars.watchers_h1["bspstate"].Current == 2}, //Split on banshee
        {2, () => vars.watchers_c40["gen1state"].Current == 1 && vars.watchers_c40["gen1state"].Old != 1}, //Split on gen1
        {3, () => vars.watchers_h1["bspstate"].Current == 10 && vars.watchers_h1["bspstate"].Old != 10}, //Split on ice bridge bsp
        {4, () => vars.watchers_h1["bspstate"].Current == 1 && vars.watchers_h1["bspstate"].Old != 1 && vars.watchers_h1xy["xpos"].Current > 275}, //Split on b1 start
        {5, () => vars.watchers_h1["bspstate"].Current == 9 && vars.watchers_h1["bspstate"].Old != 9 && vars.watchers_h1xy["xpos"].Current > 275 && vars.watchers_h1xy["ypos"].Current < -495}, //Split on b1 end
        {6, () => vars.watchers_h1["bspstate"].Current == 1 && vars.watchers_h1["bspstate"].Old != 1 && vars.watchers_h1xy["xpos"].Current < 275 && vars.watchers_h1xy["ypos"].Current < -495}, //Split on b2 start
        {7, () => vars.watchers_h1["bspstate"].Current == 8 && vars.watchers_h1["bspstate"].Old != 8 && vars.watchers_h1xy["xpos"].Current < 275}, //Split on b2 end
        {8, () => vars.watchers_c40["liftstate"].Current == 1 && vars.watchers_c40["liftstate"].Old == 0 && vars.watchers_h1["bspstate"].Current == 8}, //Split on lift
        {9, () => vars.watchers_h1xy["chiefstate"].Current == 2 && vars.watchers_h1xy["chiefstate"].Old != 2 && vars.watchers_h1["bspstate"].Current == 1}, //Split on ghost
        {10, () => vars.watchers_h1["bspstate"].Current == 6 && vars.watchers_h1["bspstate"].Old != 6}, //Split on gen2 entry
        {11, () => vars.watchers_h1xy["chiefstate"].Current == 2 && vars.watchers_h1xy["chiefstate"].Old != 2 && vars.watchers_h1["bspstate"].Current == 1}, //Split on gen2 banshee
        {12, () => vars.watchers_c40["brokendoorstate"].Current == 1 && vars.watchers_c40["brokendoorstate"].Old == 0}, //Split on broken door button
        {13, () => vars.watchers_c40["lastdoorstate"].Current == 1 && vars.watchers_c40["lastdoorstate"].Old == 0}, //Split on final door button
    };


    vars.H1_levellist = new Dictionary<string, byte[]> {
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


    //GENERAL VARS INIT - most of these need to be reinit on timer reset
    vars.startedlevel = "000";
    vars.varsreset = false;
    vars.index = 0;
    vars.dirtybsps_byte = new List<byte>();


    //SETTINGS
    settings.Add("LoadSplit", true, "Spit on loading screen");
    settings.SetToolTip("LoadSplit", "Spit on loading screen between levels (does nothing if in IL mode)");

    settings.Add("MenuSplit", false, "Spit on loading level from main menu");
    settings.SetToolTip("MenuSplit", "Spit on loading a level from the main menu. Useful for Hunter%");

    settings.Add("anylevel", false, "Start full-game runs on any level (READ THE TOOLTIP)");
    settings.SetToolTip("anylevel", "You probably don't need to use this. This option starts the timer on any level instead of just the first level for full-game runs.");

    settings.Add("CustomMap", false, "Start full-game run for a custom campaign");
    settings.SetToolTip("CustomMap", "Starts the timer for a supported custom campaign (ie Lumoria)");

    settings.Add("ILmode", false, "Individual Level mode");
    settings.SetToolTip("ILmode", "Makes the timer start, reset and ending split at the correct IL time for each level.");

    settings.Add("ILsplits", false, "Individual Level splits", "ILmode");
    settings.SetToolTip("ILsplits", "Cambid's special sauce IL splits. You will need: \n" +
        "PoA: 8 Splits \n" +
        "T&R: 6 Splits (7 on legendary) \n" +
        "SC: 5 Splits \n" +
        "TB: 15 Splits \n" +
        "Yet to add other levels");

    settings.Add("bspmode", false, "Split on unique \"Loading... Done\"'s ");
    settings.SetToolTip("bspmode", "Split on unique bsp loads (\"Loading... Done\") within levels. \n" +
        "You'll need to add a lot of extra splits for this option"
    );
    settings.Add("deathcounter", false, "Enable Death Counter");
    settings.SetToolTip("deathcounter", "Will automatically create a layout component for you. Feel free \n" +
        "to move it around, but you won't be able to rename it"
    );

    settings.Add("debug", false, "Experimental");
    settings.SetToolTip("debug", "Experimental/test features. Don't enable this unless you know what you're doing");

    settings.Add("loadremoval", false, "Remove Loads (DO NOT ENABLE)", "debug");
    settings.SetToolTip("loadremoval", "For testing only. On current HR rules, loads are still timed on Halo PC");

    //DEATH COUNTERS AND FUN
    //DEATHS
    vars.TextDeathCounter     = null;
    vars.DeathCounter         = 0;
    vars.UpdateDeathCounter = (Action)(() => {
        if(vars.TextDeathCounter == null) {
            foreach (dynamic component in timer.Layout.Components) {
                if (component.GetType().Name != "TextComponent") continue;
                
                if (component.Settings.Text1 == "Deaths:") {
                    vars.TextDeathCounter = component.Settings;
                    break;
                }
            }
            if(vars.TextDeathCounter == null) {
                vars.TextDeathCounter = vars.CreateTextComponent("Deaths:");
            }
        }
        vars.TextDeathCounter.Text2 = vars.DeathCounter.ToString();
    });

    vars.CreateTextComponent = (Func<string, dynamic>)((name) => {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        dynamic textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
        textComponent.Settings.Text1 = name;
        return textComponent.Settings;
    }); 
}

update {
    vars.watchers_h1.UpdateAll(game);
    if (timer.CurrentPhase == TimerPhase.NotRunning) {
        vars.watchers_h1xy.UpdateAll(game);
    }
    else {
        if (settings["ILmode"]) {
            string checklevel = vars.watchers_h1["levelname"].Current;
            switch (checklevel) {
                case "a10":
                    if (settings["ILsplits"]) {
                        vars.watchers_h1xy.UpdateAll(game);
                    }
                break;

                case "a50":
                    vars.watchers_h1fade.UpdateAll(game);
                    if (settings["ILsplits"]) {
                        vars.watchers_a50.UpdateAll(game);
                        vars.watchers_h1xy.UpdateAll(game);
                    }
                break;

                case "b30":
                    if (settings["ILsplits"]) {
                        vars.watchers_b30.UpdateAll(game);
                        vars.watchers_h1xy.UpdateAll(game);
                    }
                break;

                case "c40":
                    vars.watchers_h1fade.UpdateAll(game);
                    vars.watchers_c40.UpdateAll(game);
                    vars.watchers_h1xy.UpdateAll(game);
                break;

                case "d20":
                    vars.watchers_h1fade.UpdateAll(game);
                break;

                case "d40":
                    vars.watchers_h1xy.UpdateAll(game);
                break;
            }
        }

        if (settings["bspmode"]) {
            if (vars.watchers_h1["levelname"].Current == "b40" || vars.watchers_h1["levelname"].Current == "c40") {
                vars.watchers_h1xy.UpdateAll(game);
            }
        }
    }

    if (timer.CurrentPhase == TimerPhase.Running && !vars.varsreset) {
        vars.varsreset = true;
    }
    else if (timer.CurrentPhase == TimerPhase.NotRunning && vars.varsreset) {
        vars.varsreset = false;
        vars.dirtybsps_byte.Clear();
        vars.startedlevel = "000";
        vars.index = 0;

        vars.DeathCounter = 0;
        if (settings["deathcounter"]) {
            vars.UpdateDeathCounter();
        }
        print ("Autosplitter vars reinitalized!");
    }
}

start {
    if (vars.watchers_h1["levelname"].Current != "" || vars.watchers_h1["levelname"].Current != "ui") {
        if(!settings["CustomMap"]) {
            // Check that maps are build with tool, not invader-build or something.
            if((version == "Retail" && vars.watchers_h1["buildversion"].Current == "01.00.00.0564") || (version == "Custom Edition" && vars.watchers_h1["buildversion"].Current == "01.00.00.0609")) {
                foreach (var entry in vars.H1_ILstart) {
                    if (entry.Key == vars.watchers_h1["levelname"].Current && (entry.Key == "a10" || (settings["ILmode"] || settings["anylevel"]))) {
                        if (entry.Value()) {
                            vars.startedlevel = entry.Key;
                            return true;
                        }
                    }
                }
            }
        }
        else {
            foreach (var entry in vars.H1_customstart) {
                if (entry.Key == vars.watchers_h1["levelname"].Current && entry.Value()) {
                    vars.startedlevel = entry.Key;
                    return true;
                }
            }
        }
    }
}

split {
    string checklevel = vars.watchers_h1["levelname"].Current;

    //Death counter check
    if (settings["deathcounter"]) {
        if (vars.watchers_h1["deathflag"].Current && !vars.watchers_h1["deathflag"].Old) {
            print ("adding death");
            vars.DeathCounter += 1;
            vars.UpdateDeathCounter();
        }
    }


    if (settings["bspmode"] && !settings["ILsplits"]) {
        if (checklevel == "b40") {
            if (vars.watchers_h1["bspstate"].Current != vars.watchers_h1["bspstate"].Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.watchers_h1["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h1["bspstate"].Current))) {
                if (vars.watchers_h1["bspstate"].Current == 0) {
                    if (vars.watchers_h1xy["ypos"].Current > (-19.344 - 0.2) && vars.watchers_h1xy["ypos"].Current < (-19.344 + 0.2)) {
                        vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
                        return true;
                    }
                    else {
                        return false;
                    }
                } 
                else {
                    vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
                    return true;
                }
            }
        }
        else if (checklevel == "c40") {
            if (vars.watchers_h1["bspstate"].Current != vars.watchers_h1["bspstate"].Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.watchers_h1["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h1["bspstate"].Current)) && vars.watchers_h1["tickcounter"].Current > 30) {
                if (vars.watchers_h1["bspstate"].Current == 0) {
                    if (vars.watchers_h1xy["xpos"].Current > 171.87326 && vars.watchers_h1xy["xpos"].Current < 185.818526 && vars.watchers_h1xy["ypos"].Current > -295.3629 && vars.watchers_h1xy["ypos"].Current < -284.356986) {
                        vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
                        return true;
                    }
                    else {
                        return false;
                    }
                } 
                else {
                    vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
                    return true;
                }
            }
        }
        else {
            if (vars.watchers_h1["bspstate"].Current != vars.watchers_h1["bspstate"].Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.watchers_h1["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h1["bspstate"].Current))) {
                vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
                return true;
            }
        }
    }

    if (settings["ILmode"]) {
        if (settings["ILsplits"]) {
            switch (checklevel) {
                case "a10":
                    foreach (var entry in vars.H1_a10splits) {
                        if (entry.Key == vars.index) {
                            if (entry.Value()) {
                                vars.index++;
                                return true;
                            }
                        }
                    }
                break;

                case "a50":
                    // Skip the dropship split on lower than legendary difficulty
                    if (vars.index == 0 && vars.watchers_h1["difficulty"].Current != 3) {
                        vars.index++;
                    }
                    foreach (var entry in vars.H1_a50splits) {
                        if (entry.Key == vars.index) {
                            if (entry.Value()) {
                                vars.index++;
                                return true;
                            }
                        }
                    }
                break;

                case "b30":
                    foreach (var entry in vars.H1_b30splits) {
                        if (entry.Key == vars.index) {
                            if (entry.Value()) {
                                vars.index++;
                                return true;
                            }
                        }
                    }
                break;

                case "c40":
                    foreach (var entry in vars.H1_c40splits) {
                        if (entry.Key == vars.index) {
                            if (entry.Value()) {
                                vars.index++;
                                return true;
                            }
                        }
                    }
                break;
            }
        }

        foreach (var entry in vars.H1_ILendsplits) {
            if (entry.Key == vars.watchers_h1["levelname"].Current) {
                if (entry.Value()) {
		            vars.dirtybsps_byte.Clear();
                    return true;
                }
            }
        }
    }
    else {
        if ((settings["LoadSplit"] && vars.watchers_h1["levelname"].Current != "ui" && vars.watchers_h1["gamewon"].Current && !vars.watchers_h1["gamewon"].Old) 
        || (settings["MenuSplit"] && vars.watchers_h1["levelname"].Current == "ui" && vars.watchers_h1["gamewon"].Current && !vars.watchers_h1["gamewon"].Old) 
        || (vars.watchers_h1["levelname"].Current == "d40" && !vars.watchers_h1["cinematic"].Old && vars.watchers_h1["cinematic"].Current && !vars.watchers_h1["cutsceneskip"].Current)) {
		    vars.dirtybsps_byte.Clear();
            return true;
        }
    }
}

reset {
    if (settings["ILmode"]) {
        return ((vars.watchers_h1["mapreset"].Current && !vars.watchers_h1["mapreset"].Old) || (vars.watchers_h1["levelname"].Current == "ui"));
    }
    else if ((settings["anylevel"] || settings["CustomMap"] || vars.watchers_h1["levelname"].Current == "a10") && vars.watchers_h1["levelname"].Current == vars.startedlevel && timer.CurrentPhase != TimerPhase.Ended) {
        return ((vars.watchers_h1["mapreset"].Current && !vars.watchers_h1["mapreset"].Old) || (vars.watchers_h1["levelname"].Current != "ui" && vars.watchers_h1["levelname"].Old == "ui"));
    }
}

isLoading {
    if (settings["loadremoval"]) {
        return (vars.watchers_h1["levelname"].Current != "ui" && vars.watchers_h1["gamewon"].Current);
    }
    else {
        return false;
    }
}

gameTime {
}