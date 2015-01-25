/obj/item/weapon/book/manual/spacelaw
	name = "Space Law"
	icon_state ="bookSpaceLaw2"
	author = "Nanotrasen"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Space Law"
	window_size = "970x710"
	var/list/crimes = list()

//big pile of shit below.
	dat = ""

	New()
		// Populate the crime list:
		for(var/x in typesof(/datum/crime))
			var/datum/crime/F = new x(src)
			if(!F.name)
				del(F)
				continue
			else
				crimes.Add(F)
		//start up the book's format
		dat = {"<html>
					<head>
					<style>
					h1 {font-size: 18px; margin: 15px 0px 5px;}
					h2 {font-size: 15px; margin: 15px 0px 5px;}
					li {margin: 2px 0px 2px 15px;}
					ul {list-style: none; margin: 5px; padding: 0px;}
					ol {margin: 5px; padding: 0px 15px;}
					a, a:link, a:visited, a:active, a:hover { color: #000000; }img {border-style:none;}
					</style>
					</head>
					<body>
					"}
		dat += {"<h1><span><a name='top'>Space Law</span></h1><p>Space Law is a collection of rules and regulations enacted by Nanotrasen which has oversight through CentCom and is enforced by the Sec Officers on the station. Space Law applies to all ranks and positions on station, from the lowliest Assistant to the highest Captain, all are equal under the eyes of the Law and ultimately answer to her.</p>
<p>The rules and regulations herein are not absolutes, instead they exist to serve mainly as guidelines for the law and order of the dynamic situations that exist for stations on the frontiers of space, as such some leeway is permitted.</p>"}
		//Contents
		dat += "<center>"
		dat += {"<table style="text-align:left; background-color:#FFFFFF;" border="1" cellspacing="0">

				<tr>

				<th rowspan="11" valign='top' width="300px style="background-color:#FFFFFF;">
					<h3>Space Law</h3>
					<p>1)<a href='#1'>Interpretation of the Law</a></p>
					<p>2)<a href='#2'>Brig Procedures</a></p>
					<p>3)<a href='#3'>Legal Representation and Trials</a></p>
					<p>4)<a href='#4'>Use of Deadly Force</a></p>
					<p>5)<a href='#9'>Modifiers & Special Situations</a></th>"}
		dat += {"<th style="background-color:#ffee55;" valign='top' width="200px">"}
		dat += {"<a href='#5'><h3>Minor Crimes</h3></a>"}
		for(var/datum/crime/minor/crime in crimes)
			dat += {"<font size = 2><a href='#[crime.name]'>1[crime.code]) [crime.name]</a></font><br>"}
		dat += {"<th style="background-color:#ffaa55;" valign='top' width="200px">"}
		dat += {"<a href='#6'><h3>Medium Crimes</h3></a>"}
		for(var/datum/crime/medium/crime in crimes)
			dat += {"<font size = 2><a href='#[crime.name]'>2[crime.code]) [crime.name]</a></font><br>"}
		dat += {"<th style="background-color:#ff6655;" valign='top' width="200px">"}
		dat += {"<a href='#7'><h3>Major Crimes</h3></a>"}
		for(var/datum/crime/major/crime in crimes)
			dat += {"<font size = 2><a href='#[crime.name]'>3[crime.code]) [crime.name]</a></font><br>"}
		dat += {"<th style="background-color:white;" valign='top' width="200px">"}
		dat += {"<a href='#8'><h3>Capital Crimes</h3></a>"}
		for(var/datum/crime/capital/crime in crimes)
			dat += {"<font size = 2><a href='#[crime.name]'>4[crime.code]) [crime.name]</a></font><br>"}
		dat += "</table>"
		dat += "</center>"
		//Space law
		dat += {"
<h4><span><a name='1'>Interpretation of the Law</span></h4>
<p style="padding-left:30px;">A good working knowledge of Space Law is important for any person on the station. It can be the difference between a shiny pair of handcuffs and sipping Gargle Blasters in the bar. More in depth interpretations of space law are required for such positions as the Lawyer, Warden, HoP, and the HoS. While it is unlikely that the officers will listen particularly closely to your protestations, it may be enough to lighten your sentence and avoid ill treatment by security.</p>
<p style="padding-left:30px;">For certain crimes, the accused's intent is important. The difference between Assault and Attempted Murder can be very hard to ascertain, and, when in doubt, you should default to the less serious crime. It is important to note though, that Assault and Attempted Murder are mutually exclusive. You cannot be charged with Assault and Attempted Murder from the same crime as the intent of each is different. Likewise, 'Assault With a Deadly Weapon' and 'Assaulting an Officer' are also crimes that exclude others. Pay careful attention to the requirements of each law and select the one that best fits the crime when deciding sentence.</p>
<p style="padding-left:30px;">In the case of violent crimes (Assault, Manslaughter, Attempted Murder and Murder), and theft (Petty Theft, Pick-Pocketing, Theft, and Grand Theft) take only the most severe.</p>
<p style="padding-left:30px;">A single incident has a single sentence, so if, for instance, the prisoner took three items off of someone, this is a single count of pick-pocketing, if they pick-pocketed two people this would be two separate counts of pick-pocketing, and so on.</p>
<p style="padding-left:30px;">Aiding a criminal makes you an accomplice; you can be charged with the same crime as the person you aided.</p>
<p style="padding-left:30px;"></p>
<h4><span><a name='2'>Brig Procedures</span></h4>
<p style="padding-left:30px;">Standard Operational Procedures for brigging are as follows:</p>
<ol><li><span>Take the prisoner to the brig and inform the Warden of their crimes so their Security Record may be updated.</span></li>
<li><span>Take the prisoner to a brig cell, set the time and activate the timer.</span></li>
<li><span>Enter the cell with the prisoner in tow, open the cell locker and hold the prisoner over it.</span></li>
<li><span>Empty their pockets and remove their gloves, backpacks, tool belt, gas masks, and any flash resistant equipment such as Sunglasses, Welding Masks/Goggles, Space Helmets, etc.</span></li>
<li><span>Buckle the prisoner to the bed.</span></li>
<li><span>Search the items removed and be sure to check the internals box in their backpack.</span></li>
<li><span>Confiscate any contraband and/or stolen items, as well as any tools that may be used for future crimes. </span></li>
<li><span>These are to be placed in evidence, </span><strong>not left on the brig floor or your personal use</strong><span>, until they can be returned to their rightful owners.</span></li>
<li><span>Close the locker and </span><strong>lock it</strong><span>.</span></li>
<li><span>Flash the prisoner, remove their cuffs, pick up the cuffs then leave the cell.</span></li>
<li><span>Modify their brig sentence for additional offences or good behavior, if applicable.</span></li>
</ol><p style="padding-left:30px;"><strong>Do</strong> <em>NOT</em> <strong>fully strip the prisoner unless they have earned a permanent sentence.</strong><br />In the event of a sentence exceeding the 10 minute limit of the timer inform the Warden so he may add the rest of the time later.</p>
<p style="padding-left:30px;">In the instance of prisoners that have earned Labor Camp duty, you must dress them in orange overalls and assign them targets, based on their sentence, by getting a prison ID, putting it in a Prisoner Management Console, assigning their quota (conversion rate of 100 points per minute otherwise served in the brig) and then giving them the ID as you ship them to the Labor Camp. There are more details on this procedure at Labor Camp.</p>
<p style="padding-left:30px;">In the instances of prisoners that have earned permanent detention it is the duty, under normal circumstances, of the Warden or Head of Security to process these prisoners. <br />Permanent Prisoners are to be completely stripped of their belongings, which are to be held in either evidence or a prison locker. <br />The prisoner is to be dressed in an Orange Prison Jumpsuit and Shoes, which are found in the prison lockers.<br />Permanent Prisoners are not permitted to possess any personal belongings whilst they are incarcerated in the Prison Wing. The Labor Camp can also be used to hold Permanent Prisoners. Simply do not issue a prisoner ID when transferring them to the camp.</p>
<h4><span><a name='3'>Legal Representation and Trials</span></h4>
<p style="padding-left:30px;">Prisoners are permitted to seek legal representation however you are under no obligation to provide or allow this.</p>
<p style="padding-left:30px;">Lawyers, and by extension the Head of Personnel, exist to serve as a guiding hand and the voice of reason within the judicial process, however they have zero authority over the brig, security personnel, prisoners, or sentencing. <br />The Lawyer's security headset is a privilege not a right. Security personnel are under no requirement to listen to them and security channel abuse is to result in that privilege being revoked. <br />If the lawyer continuously acts as a disruptive influence Security are fully permitted to confiscate their access, remove them from the brig and bar their future access to it.</p>
<p style="padding-left:30px;">In instances where a conflict of opinion arises over the sentence of a prisoner the chain of command <strong>must</strong> be followed. This goes, from top to bottom: Captain &gt; Head of Security &gt; Warden &gt; Sec Officer / Detective.</p>
<p style="padding-left:30px;">Trials are not to be performed for Timed Sentences. This is mainly for the benefit of the accused as trials will often run many times the length of the actual sentence. <br />Trials may be performed for Capital Crimes and Permanent Detention, however there is no requirement to hold them. Forensic Evidence, Witness Testimony, or Confessions are all that is required for the Head of Security, Warden or Captain to authorize their sentence.<br />In cases where the Death Penalty is desired but the Captain or Acting-Captain is unable or unwilling to authorize the execution a trial <strong>is required</strong> to authorize the death penalty.</p>
<h4><span><a name='4'>Use of Deadly Force</span></h4>
<p style="padding-left:30px;">As a member of the stations Security force you are one of the best armed and protected people on the station, equipped with the almost latest in non-lethal take down technology.<br />It is for this reason that the situations that warrant the use of Deadly Force are few and far between, in the grand majority of circumstances you will be expected to use your stun weapons, which indeed are many times more effective than lethal options, to diffuse a situation.</p>
<p style="padding-left:30px;">However there are certain circumstances where deadly force is permissible:</p>
<ul><li><strong>Code Red Situation</strong><span> - situations which would warrant a Code Red, such as: full blown mutinies, hostile boarding parties, and Space Wizards automatically authorize lethal force. </span></li>
<li><span>Note: The Alert Status is not required to be elevated to Code Red as in most of these scenarios the Chain of Command will be too damaged or otherwise occupied to raise the Alert Level.</span></li>
<li><strong>Non-Lethal Weapons Ineffective</strong><span> - certain targets are impervious to NLWs, such as Mechs, Xenomorphs, Borgs, and Hulks. Lethal force may be used against these targets if they prove hostile.</span></li>
<li><strong>Severe Personal Risk</strong><span> - sometimes getting close enough to a target to slap the cuffs on will create significant personal risk to the Officer. Deadly force from range is recommended to subdue Wizards and Changelings. </span></li>
<li><span>Criminals in hostile environments such as space, fire, or plasma leaks also fall into this category, as do criminals believed to be in possession of high explosives. Ranged lethal force is the only reasonable option in these conditions.</span></li>
<li><strong>Armed and Dangerous</strong><span> - if a suspect is in possession of weapons, including stun weapons, and you have reasonable suspicion that they will use these against you, lethal force is permitted. Although in the majority of cases it is still preferable to attempt to detain them non-lethally. </span></li>
<li><span style="text-decoration:underline;">Note: Unauthorised personnel in the armory are considered by default to be Armed and Dangerous, maximum force is permitted to subdue such targets.</span></li>
<li><strong>Multiple Hostiles</strong><span> - it can be extremely difficult to detain multiple hostiles. </span><strong>As a last resort</strong><span> if you are being mobbed you may deploy your baton in a harmful manner to thin the crowd. Generally it is better to retreat and regroup than stand your ground.</span></li>
</ul><p style="padding-left:30px;">Additionally, in the event of an attempted prison break, the Warden and Head of Security may fire lasers through the glass. They are expected to first fire a few warning shots before unloading their weapon into the target.</p>"}

		//Crime Listing
		dat += "<center>"
		dat += {"<h3><a name='5'>Minor Crimes </span></h3>
				<p>All of these crimes carry a 1 minute sentence.
				</p>
				<table width="825px" style="text-align:center; background-color:#ffee99;" border="1" cellspacing="0">
				<tr>
				<th style="background-color:#ffee55;" width="20px">Code
				</th>
				<th style="background-color:#ffee55;" width="130px">Crime
				</th>
				<th style="background-color:#ffee55;" width="300px">Description
				</th>
				<th style="background-color:#ffee55;" width="300px">Notes
				</th></tr>"}
		for(var/datum/crime/minor/crime in crimes)
			dat += {"
				<tr>
				<td><span id="[crime.name]">[crime.categorycode][crime.code]
				</td>
				<td><b>[crime.name]
				</td>
				<td> [crime.description]
				</td>
				<td> [crime.notes]
				</td></tr>"}
		dat += {"</table>"}
		dat += {"<h3><a name='6'>Medium Crimes </span></h3>
				<p>All of these crimes carry a 2 minute sentence or a 100 point target at the Labor Camp, optional for the suspect you are arresting.
				</p>
				<table width="825px" style="text-align:center; background-color:#ffcc99;" border="1" cellspacing="0">
				<tr>
				<th style="background-color:#ffaa55;" width="20px">Code
				</th>
				<th style="background-color:#ffaa55;" width="130px">Crime
				</th>
				<th style="background-color:#ffaa55;" width="300px">Description
				</th>
				<th style="background-color:#ffaa55;" width="300px">Notes
				</th></tr>"}
		for(var/datum/crime/medium/crime in crimes)
			dat += {"
				<tr>
				<td><span id="[crime.name]">[crime.categorycode][crime.code]
				</td>
				<td><b>[crime.name]
				</td>
				<td> [crime.description]
				</td>
				<td> [crime.notes]
				</td></tr>"}
		dat += {"</table>"}
		dat += {"<h3><a name='7'>Major Crimes </span></h3>
				<p>These crimes carry a service at the Labor Camp, with a 500 point target or a five minute brig sentence.
				</p>
				<table width="825px" style="text-align:center; background-color:#ffaa99;" border="1" cellspacing="0">
				<tr>
				<th style="background-color:#ff6655;" width="20px">Code
				</th>
				<th style="background-color:#ff6655;" width="130px">Crime
				</th>
				<th style="background-color:#ff6655;" width="300px">Description
				</th>
				<th style="background-color:#ff6655;" width="300px">Notes
				</th></tr>"}
		for(var/datum/crime/major/crime in crimes)
			dat += {"
				<tr>
				<td><span id="[crime.name]">[crime.categorycode][crime.code]
				</td>
				<td><b>[crime.name]
				</td>
				<td> [crime.description]
				</td>
				<td> [crime.notes]
				</td></tr>"}
		dat += {"</table>"}
		dat += {"<h3><a name='8'>Capital Crimes</span></h3>
				<p>These crimes can result in Execution, Permanent Prison Time, Permanent Labor Camp Time, or Cyborgization. <br />
				Only the Captain, HoS, and Warden can authorize a Permanent Sentence. <br />
				Only the Captain can authorize an Execution or Forced Cyborgization. <br />
				</p>
				<table width="825px" style="text-align:center; background-color:dimgray; color:white" border="1" cellspacing="0">
				<tr>
				<th style="background-color:black;" width="20px">Code
				</th>
				<th style="background-color:black;" width="130px">Crime
				</th>
				<th style="background-color:black;" width="300px">Description
				</th>
				<th style="background-color:black;" width="300px">Notes
				</th></tr>"}
		for(var/datum/crime/capital/crime in crimes)
			dat += {"
				<tr>
				<td><span id="[crime.name]">[crime.categorycode][crime.code]
				</td>
				<td><b>[crime.name]
				</td>
				<td> [crime.description]
				</td>
				<td> [crime.notes]
				</td></tr>"}
		dat += {"</table>"}
		//Modifiers
		dat += {"
				<h3> <a name='9'> Modifiers &amp; Special Situations </span></h3>
				<table width="825px" style="text-align:center; background-color:#aaffaa;" border="1" cellspacing="0">
				<tr>
				<th style="background-color:#55ff55;" width="150px">Situation
				</th>
				<th style="background-color:#55ff55;" width="300px">Description
				</th>
				<th style="background-color:#55ff55;" width="100px">Modification
				</th></tr>
				<tr>
				<td><b>Surrender</b>
				</td>
				<td> Coming to the brig, confessing what you've done and taking the punishment. Getting arrested without putting a fuss is not surrender. For this, you have to actually come to the brig yourself.
				</td>
				<td> -25%, and should be taken into account when the choice between life in a secure cell, execution, and cyborgization is made.
				</td></tr>
				<tr>
				<td><b>Re-education</b>
				</td>
				<td> Getting de-converted from revolutionary.
				</td>
				<td> -Immediate release
				</td></tr>
				<tr>
				<td><b>Cooperation with prosecution or security</b>
				</td>
				<td> Being helpful to the members of security, revealing things during questioning or providing names of head revolutionaries.
				</td>
				<td> -25%; in the case of revealing a head revolutionary: Immediate release
				</td></tr>
				<tr>
				<td><b>Immediate threat to the prisoner</b>
				</td>
				<td> The singularity eats something near the brig, an explosion goes off, etc.
				</td>
				<td> Officer must relocate the prisoner(s) to a safe location; otherwise, immediate release.
				</td></tr>
				<tr>
				<td><b>Medical reasons</b>
				</td>
				<td> Prisoners are entitled to medical attention if sick or injured.
				</td>
				<td> Medical personnel can be called, or the prisoner can be escorted to the Medbay. The timer continues to run during this time.
				</td></tr>
				<tr>
				<td><b>Sparking a Manhunt</b>
				</td>
				<td>  In addition to Resisting Arrest, a prisoner that must be chased for at least 2 minutes after an arrest is attempted can have their sentence increased.
				</td>
				<td> 1 minute added to their sentence for every 2 minutes the chase lasted.
				</td></tr>
				<tr>
				<td><b>Self Defense</b>
				</td>
				<td>  Self Defense is defined as "The protection of oneself, the protection of thy colleagues, and the protection of thine workplace". <br />Do note however that persons intentionally getting involved in fights which occur in a department that isn't theirs is an act of vigilantism, this is not permitted.
				</td>
				<td> Immediate release.
				</td></tr>
				<tr>
				<td><b>Escape from Brig</b>
				</td>
				<td>  If a prisoner flees confinement for any reason other than to escape impending lethal danger (fire, hull breach, murder), reset their timer to their full original punishment.
				</td>
				<td> Reset timer
				</td></tr>
				<tr>
				<td><b>Repeat Offender</b>
				</td>
				<td> If a convict reoffends after being released they may receive a harsher punishment. Depending on the severity of the crimes committed after the third, or even second, strike their sentence may be increased to Permanent Imprisonment.
				</td>
				<td> Additional brig time
				</td></tr>
				<tr>
				<td><b>Aiding and Abetting</b>
				</td>
				<td> Knowingly assisting a criminal is a crime. This includes but is not limited to: Interfering with an arrest, stealing a prisoner in transit, breaking a prisoner out of the brig/prison, hiding a fugitive, providing medical care (unless paired with a large dose of sleep toxins).
				</td>
				<td> The same sentence as the original criminal
				</td></tr></table>"}
		dat += "</center>"
		//close off the book
		dat += {"
					</body>
					</html>
					"}

