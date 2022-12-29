// Amok Runner Load Remover & Autosplitter Version 1.0 28/12/2022
// Supports Load Remover IGT
// Splits for campaigns can be obtained from 
// Script by TheDementedSalad
// Levels found by by yobson


state("Amok-Win64-Shipping", "SteamRelease")
{
	byte Loading 	:	0x46A6B10, 0x168, 0x8, 0x2218, 0x8;
	byte Level 		:	0x4BAC550, 0x8, 0x8, 0x9A0, 0x70, 0x278, 0x30;
	byte Final		:	0x498A010, 0x118, 0x280, 0x480, 0x78, 0x0, 0x0, 0x88, 0x8;
	float X			:   0x4989A18, 0x98, 0x8C8, 0x3E8, 0x130, 0x10;
	float Y			:   0x4989A18, 0x98, 0x8C8, 0x3E8, 0x130, 0x18;
	float Z			:   0x4989A18, 0x98, 0x8C8, 0x3E8, 0x130, 0x14;
	string128 Map 	:	0x4BAC598, 0xD28, 0x30, 0xF8, 0x20;

}

init
{
	switch (modules.First().ModuleMemorySize)
	{
		case (84217856):
			version = "SteamRelease";
			break;
	}
}

startup
{
	if (timer.CurrentTimingMethod == TimingMethod.RealTime){ // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
		var timingMessage = MessageBox.Show (
			"This game uses Time without Loads (Game Time) as the main timing method.\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"Would you like to set the timing method to Game Time? This will make verification easier",
			"LiveSplit | Amok Runner",
		MessageBoxButtons.YesNo,MessageBoxIcon.Question);
		
		if (timingMessage == DialogResult.Yes){
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
	
	vars.completedSplits = new List<byte>();
	
	vars.splitnames = new List<string>()
	{"Begin Clinic","Finish Clinic","Reach Train Station","Reach House","Reach Abandoned House Grounds","Start Lowering Ladder","Enter Abandoned House","Leave Abandoned House","Finish Encounter",
	"Reach Mansions Grounds","Enter Planet Building","Enter Mansion","Exit Mansion","Reach Town","Reach Clinic","Help Lady","RIP Lady","Begin Car Escape","Begin Cemetery","Begin Final Boss","Killed Final Boss","Reached Ship"};
	
	vars.splits = new List<byte>()
	{1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
	
	settings.Add("Auto", false, "Enable Autosplitter");
	settings.CurrentDefaultParent = "Auto";
		for(int i = 0; i < 22; i++){
        	settings.Add("" + vars.splits[i].ToString(), false, "" + vars.splitnames[i].ToString());
    	}
		settings.CurrentDefaultParent = null;

	
	settings.Add("End", true, "End Split - Always Active");
}

update
{
	// Uncomment debug information in the event of an update.
	//print(modules.First().ModuleMemorySize.ToString());
	
	if(timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.completedSplits.Clear();
	}
}

start
{
	return current.Loading == 2 && old.Loading == 3 && current.Level == 0;
}

split
{
	if(settings["Auto"]){
		for(int i = 0; i < 22; i++){
				if(vars.splits.Contains(current.Level) && !vars.completedSplits.Contains(current.Level) && settings["" + current.Level] && current.Map != "AmokEntry"){
				vars.completedSplits.Add(current.Level);
				return true;
			}
		}
	}
	
	if(current.Level == 23 && current.X > -57145f && current.X < -57140f && current.Final == 1 && old.Final == 6){
			return true;
		}
	
	else return false;
}

isLoading
{
	return current.Loading == 3 || current.Map == "AmokEntry";
}

reset
{
	return current.Map == "Amoktown" && old.Map == "AmokEntry" && current.Level == 0;
}
