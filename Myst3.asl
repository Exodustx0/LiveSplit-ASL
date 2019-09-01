state("residualvm", "GOG (25th Anniv.)"){
	int node: "residualvm.exe", 0x0071B5A8, 0x4C, 0x16C;
	int room: "residualvm.exe", 0x0071B5A8, 0x4C, 0x168;
}

state("residualvm", "DVD (25th Anniv.)"){
	int node: "residualvm.exe", 0x004ED0A8, 0x4C, 0x16C;
	int room: "residualvm.exe", 0x004ED0A8, 0x4C, 0x168;
}

state("residualvm", "Steam (25th Anniv.)"){
	int node: "residualvm.exe", 0x004EC0A8, 0x4C, 0x16C;
	int room: "residualvm.exe", 0x004EC0A8, 0x4C, 0x168;
}

init{
	// I robbed this md5 code from Gelly's Myst autosplitter who robbed it from CptBrian's RotN autosplitter
	// Shoutouts to them
	byte[] exeMD5HashBytes = new byte[0];
	using (var md5 = System.Security.Cryptography.MD5.Create())
	{
		using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
		{
			exeMD5HashBytes = md5.ComputeHash(s); 
		} 
	}
	var MD5Hash = exeMD5HashBytes.Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
	print("MD5Hash: " + MD5Hash.ToString());
	
	if(MD5Hash == "67BAFA45FC3EE1F4211A26FCC65CF73E"){
		print("GOG version.");
		version = "GOG (25th Anniv.)";
	}else if(MD5Hash == "60C57D14483233F5C71B7B5A04938621"){
		print("DVD version.");
		version = "DVD (25th Anniv.)";
	}else if(MD5Hash == "F280D868DF58DC05DD55352DDA474433"){
		print("Steam version.");
		version = "Steam (25th Anniv.)";
	}else{
		print("Unsupported version.");
	}
}

startup{
	settings.Add("list", true, "Split configuration:");
	settings.Add("toho2leis", false, "Link from Tomahna to J'nanin.", "list");
	settings.Add("lemt2mais", true, "Link from J'nanin to Amateria.", "list");
	settings.Add("mato2leos", true, "Link from Amateria to J'nanin.", "list");
	settings.Add("lelt2lidr", true, "Link from J'nanin to Edanna.", "list");
	settings.Add("line2leos", true, "Link from Edanna to J'nanin.", "list");
	settings.Add("leet2ensi", true, "Link from J'nanin to Voltaic.", "list");
	settings.Add("enli2leos", true, "Link from Voltaic to J'nanin.", "list");
	settings.Add("leos2nach", false, "Link from J'nanin to Narayan.", "list");
	settings.Add("end", true, "Lose control to ending cutscene.", "list");
	settings.SetToolTip("end", "This autosplitter is not aware of if you get good ending or not, it will simply split when the ending cutscene is triggered.");
	
	settings.Add("menuReset", false, "Reset upon returning to menu.");
	settings.SetToolTip("menuReset", "Obviously, if you enable this, you must be sure to never accidentally go to the menu during a run. Doesn't reset automatically after finished run.");
}

start{
	if(old.room == 901 && old.node == 100 && current.room != 901){
		return true;
	}
}

split{
	if(settings["toho2leis"] && old.room == 301 && current.room == 501){
		// Tomahna to J'nanin
		return true;
	}else if(settings["lemt2mais"] && old.room == 505 && current.room == 1002){
		// J'nanin to Amateria
		return true;
	}else if(settings["mato2leos"] && old.room == 1006 && current.room == 502){
		// Amateria to J'nanin
		return true;
	}else if(settings["lelt2lidr"] && old.room == 504 && current.room == 601){
		// J'nanin to Edanna
		return true;
	}else if(settings["line2leos"] && old.room == 605 && current.room == 502){
		// Edanna to J'nanin
		return true;
	}else if(settings["leet2ensi"] && old.room == 503 && current.room == 701){
		// J'nanin to Voltaic
		return true;
	}else if(settings["enli2leos"] && old.room == 708 && current.room == 502){
		// Voltaic to J'nanin
		return true;
	}else if(settings["leos2nach"] && old.room == 502 && current.room == 801){
		// J'nanin to Narayan
		return true;
	}else if(settings["end"] && current.room == 401 && old.node == 1 && current.node != 1){
		// Trigger ending cutscene; doesn't check for good ending, just *an* ending
		return true;
	}else{
		return false;
	}
}

reset{
	if(settings["menuReset"]){
		if(old.room != 901 && current.room == 901 && old.room != 401){
			// Reset when transition to menu, except when after credits
			return true;
		}
	}
}