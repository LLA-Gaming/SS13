

datum
	crime
		var/code = ""
		var/name = ""
		var/category = ""
		var/description = ""
		var/notes = ""
		var/categorycode = ""
		var/time = 0
		var/labor = 0
		var/active = 0
		minor
			category = "Minor"
			categorycode = "1"
			time = 60
			resisting
				code = "01"
				name = "Resisting Arrest"
				description = "To not cooperate with an officer who attempts a proper arrest."
				notes = "Follow proper arrest procedure and have a legitimate cause to arrest in the first place before you brig a suspect for this. Suspects who scream bloody murder while being arrested are not cooperating."
			drugs
				code = "04"
				name = "Possession, Drugs"
				description = "To possess space drugs or other narcotics by unauthorised personnel."
				notes = "Botanists and MedSci staff are authorised to possess drugs for purposes of their jobs and are not subject to this law so long as they are not distributing or using them for profit or recreation."
			indecent_exposure
				code = "06"
				name = "Indecent Exposure"
				description = "To be intentionally and publicly unclothed."
				notes = "Running around the station naked. The mutual degradation of chasing a naked man down while he screams rape is only worth it on slow shifts."
			vandalism
				code = "07"
				name = "Vandalism"
				description = "To deliberately damage the station without malicious intent."
				notes = "Sentence depends on quantity of property damaged."
			trespass
				code = "09"
				name = "Trespass"
				description = "To be in an area which a person does not have access to. This counts for general areas of the ship, and trespass in restricted areas is a more serious crime."
				notes = "Remember that people can either break in, sneak in, or be let in. Always check that the suspect wasn't let in to do a job by someone with access, or were given access on their ID. Trespassing and theft are often committed together; both sentences should be applied."

		medium
			category = "Medium"
			categorycode = "2"
			time = 120
			labor = 100
			assault
				code = "01"
				name = "Assault"
				description = "To use physical force against someone without the apparent intent to kill them."
				notes = "Depending on the amount and kind of force used, severe instances should be elevated to attempted manslaughter or even murder. Assaults with deadly weapons are a higher crime."
			pickpocketing
				code = "02"
				name = "Pick-Pocketing"
				description = "To steal items from another's person."
				notes = "Remember to take the stolen items from the person and arrange for their return. Stealing an ID is the most common and most serious form of pick-pocketing."
			narcotics
				code = "03"
				name = "Narcotics Distribution"
				description = "To distribute narcotics and other controlled substances."
				notes = "Forcing or tricking someone to consume substances such as space drugs is assault."
			possesion_of_weapon
				code = "04"
				name = "Possession, Weapons"
				description = "To be in possession of a dangerous item that is not part of their job role."
				notes = "Items capable of a high level of damage, such as saws, axes, and hatchets fit into this category. Do remember that if it is an item that is part of their job they are permitted to carry it."
			rioting
				code = "06"
				name = "Rioting"
				description = "To partake in an unauthorised and disruptive assembly of crewmen that refuse to disperse."
				notes = "It is required to order the crowd to disperse, failure to disperse is the crime not the assembly. Any crimes committed during the riot are considered separate offences."
			workplace_hazard
				code = "07"
				name = "Creating a Workplace Hazard"
				description = "To endanger the crew or station through negligent or irresponsible, but not deliberately malicious, actions."
				notes = "Good examples of this crime involves accidentally causing a plasma leak, slipping hazard, accidently electrifying doors, breaking windows to space, or Security personnel not keeping their equipment secure."
			petty_theft
				code = "08"
				name = "Petty Theft"
				description = "To take items from areas one does not have access to or to take items belonging to others or the station as a whole."
				notes = "Keeping items which are in short supply where they belong is what is important here. A doctor who takes all the surgical tools and hides them still commits theft, even though he had access."
			breaking_and_entry
				code = "10"
				name = "Breaking and Entry"
				description = "Forced entry to areas where the subject does not have access to. This counts for general areas, and breaking into restricted areas is a more serious crime."
				notes = "Crew can still be charged with breaking & entry even if they do not enter the area themselves."
			insubordination
				code = "11"
				name = "Insubordination"
				description = "To disobey a lawful direct order from one's superior officer."
				notes = "Charge issued by a head of staff to one of their direct subordinates. The person is usually demoted instead of incarcerated. Security is expected to assist the head in carrying out the demotion."

		major
			category = "Major"
			categorycode = "3"
			time = 300
			labor = 500
			assault_deadlyweapon
				code = "01"
				name = "Assault With a Deadly Weapon"
				description = "To use physical force, through a deadly weapon, against someone without the apparent intent to kill them."
				notes = "Any variety of tools, chemicals or even construction materials can inflict serious injury in short order. If the victim was especially brutalized, consider charging them with attempted murder."
			assault_officer
				code = "02"
				name = "Assault of an Officer"
				description = "To use physical force against a Department Head or member of Security without the apparent intent to kill them."
				notes = "Criminals who attempt to disarm or grab officers while fleeing are guilty of this, even if bare handed. Officers should refrain from using lethal means to subdue the criminal if possible."
			manslaughter
				code = "03"
				name = "Manslaughter"
				description = "To unintentionally kill someone through negligent, but not malicious, actions."
				notes = "Intent is important. Accidental deaths caused by negligent actions, such as creating workplace hazards (e.g. gas leaks), tampering with equipment, excessive force, and confinement in unsafe conditions are examples of Manslaughter."
			possesion_r_weapon
				code = "04"
				name = "Possession, Restricted Weapons"
				description = "To be in possession of a restricted weapon without prior authorisation, such as: Guns, Batons, Flashes, Grenades, etc."
				notes = "Any item that can cause severe bodily harm or incapacitate for a significant time. The following personnel have unrestricted license to carry weapons and firearms: Captain, HoP, all Security Personnel.The Barman is permitted his double barrel shotgun loaded with beanbag rounds. Only the Captain and HoS can issue weapon permits."
			possesion_explosives
				code = "05"
				name = "Possession, Explosives"
				description = "To be in possession of an explosive device."
				notes = "Scientists and Miners are permitted to possess explosives only whilst transporting them to the mining asteroid, otherwise their experimental bombs must remain within the Science department."
			inciting_a_riot
				code = "06"
				name = "Inciting a Riot"
				description = "To attempt to stir the crew into a riot"
				notes = "Additionally to the brig time the offender will also have restrictions placed on their radio traffic and be implanted with a tracking implant. For second offences or outright instigating violent uprisings consider charging with Mutiny."
			sabotage
				code = "07"
				name = "Sabotage"
				description = "To hinder the work of the crew or station through malicious actions."
				notes = "Deliberately releasing N2O, bolting doors, disabling the power network, and constructing barricades are but some of many means of sabotage. For more violent forms, see Grand Sabotage."
			theft
				code = "08"
				name = "Theft"
				description = "To steal restricted or dangerous items"
				notes = "Weapons fall into this category, as do valuable items that are in limited supply such as insulated gloves, spacesuits, and jetpacks. Note that Cargo breaking open crates to illegally arm and armor themselves are guilty of theft."
			major_trespass
				code = "09"
				name = "Major Trespass"
				description = "Being in a restricted area without prior authorisation. This includes any Security Area, Command area (including EVA), the Engine Room, Atmos, or Toxins Research."
				notes = "Being in a very high security area, such as the armoury or the Captain's Quarters, is a more serious crime, and warrants a time of 10 minutes with a possible permabrigging if intent is believed to be malicious."
			breaking_and_entry_restricted
				code = "10"
				name = "Breaking and Entry, Restricted Area"
				description = "This is breaking into any Security area, Command area (Bridge, EVA, Captains Quarters, Teleporter, etc.), the Engine Room, Atmos, or Toxins research."
				notes = "As a major crime sentences start at 5 minutes, but can be extended if security believes break in was for attempted Grand Theft or attempted Grand Sabotage (yellow gloves don't count as grand theft)."
			dereliction
				code = "11"
				name = "Dereliction of Duty"
				description = "To willfully abandon an obligation that is critical to the station's continued operation."
				notes = "A demotion is often included in the sentence. Emphasis on the word critical: An officer taking a break is not dereliction in of itself. An officer taking a break knowing that operatives are shooting up the Captain is. Engineers who do not secure a power source at the start of the shift and heads of staff who abandon the station can also be charged."

		capital
			category = "Capital"
			categorycode = "4"
			murder
				code = "01"
				name = "Murder"
				description = "To maliciously kill someone."
				notes = "Punishment should fit the nature of both the crime and the criminal. Murder committed by temporary emotional distress, such as fear or anger, warrants lower punishments. Cyborg candidates must have brains fit to obey relevant laws. Life imprisonment is the most humane option for the insane who might malfunction as cyborgs. Unauthorised executions are classed as Murder."
			assault_sexual
				code = "02"
				name = "Sexual Assault"
				description = "To assault someone sexually"
				notes = "Involentary sexual contact that occurs through the actors use of force or the victim's incapacitation."
			murder_attempt
				code = "03"
				name = "Attempted Murder"
				description = "To use physical force against a person until that person is in a critical state with the apparent intent to kill them."
				notes = "Remember, if a person attempts to render first aid after the victim falls into a critical state they may not have intend to kill them"
			mutiny
				code = "06"
				name = "Mutiny"
				description = "To act individually, or as a group, to overthrow or subvert the established Chain of Command without lawful and legitimate cause."
				notes = "Mutiny is not as clear cut as it may seem, there may be a legitimate reason for their actions, such as their head of staff being utterly incompetent. This is one of the few crimes where it is recommended to always seek a third party opinion. If their actions are determined to be for the betterment of Nanotrasen consider a timed sentence or even a full pardon."
			sabotage_grand
				code = "07"
				name = "Grand Sabotage"
				description = "To engage in maliciously destructive actions, seriously threatening crew or station."
				notes = "Bombing, arson, releasing viruses, deliberately exposing areas to space, physically destroying machinery or electrifying doors all count as Grand Sabotage."
			theft_grand
				code = "08"
				name = "Grand Theft"
				description = "Syndicate agents frequently attempt to steal cutting-edge technology, intelligence or research samples, including Rapid Construction Devices (RCD), Hand Teleporter, the Captain's Antique Laser, Captain or HoP's ID cards, or Mechs."
				notes = "Syndicate agents frequently attempt to steal cutting-edge technology, intelligence or research samples, including Captains/Head of Personal/Head of Security ID's, Albative/Bulletproof Armor, Captain's Antique Laser, Captain's Armor, RCD, CE's Hardsuit, The AI, Reactive Teleport Armor, Perseus Equipment, Nuke Disk, Station Blueprints, Hypospray, Hand Teleporter, and Mechs"
			syndicate
				code = "11"
				name = "Enemy of the Corporation"
				description = "To act as, or knowingly aid, an enemy of Nanotrasen."
				notes = "Current enemies of Nanotrasen currently include: The Syndicate (through secret agents, boarding parties, and brainwashing specialists), The Wizard Federation, The Changeling Hivemind, and The Cult of Nar'Sie. Note that this is one of the few crimes where you may summarily execute someone for if they present a significant risk to detain them."
