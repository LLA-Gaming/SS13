// Totally not stolen from changeling evolution menu or anything - Ahbahl
/mob/living/simple_animal/borer/proc/upgrade_menu()
	set category = "Borer"
	set name = "-Upgrade Menu-" //Dashes are so it's listed before all the other abilities.
	set desc = "Choose an upgrade to make yourself stronger."

	if(!usr || !usr.mind || !isborer(usr))
		return
	var/mob/living/simple_animal/borer/B = usr

	var/dat = create_menu(B)
	usr << browse(dat, "window=upgrades;size=600x700")//900x480

/mob/living/simple_animal/borer/proc/create_menu(var/mob/living/simple_animal/borer/B)
	var/dat
	dat +="<html><head><title>Upgrade Menu</title></head>"

	//javascript, the part that does most of the work~
	dat += {"

		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch(){


					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != ""){
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == ""){
						return;
					}else{

						var maintable_data = document.getElementById('maintable_data');
						var ltr = maintable_data.getElementsByTagName("tr");
						for ( var i = 0; i < ltr.length; ++i )
						{
							try{
								var tr = ltr\[i\];
								if(tr.getAttribute("id").indexOf("data") != 0){
									continue;
								}
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\[0\];
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\[0\];
								//var inner_span = li.getElementsByTagName("span")\[1\] //Should only ever contain one element.
								//document.write("<p>"+search.innerText+"<br>"+filter+"<br>"+search.innerText.indexOf(filter))
								if ( search.innerText.toLowerCase().indexOf(filter) == -1 )
								{
									//document.write("a");
									//ltr.removeChild(tr);
									td.innerHTML = "";
									i--;
								}
							}catch(err) {   }
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();

				}

				function expand(id,name,desc,helptext,upgrade,ownsthis){

					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";

					body += "</td><td align='center'>";

					body += "<font size='2'><b>"+desc+"</b></font> <BR>"

					body += "<font size='2'><font color = 'red'><b>"+helptext+"</b></font> <BR>"

					if(!ownsthis)
					{
						body += "<a href='?src=\ref[src];U="+upgrade+"'>Evolve</a>"
					}
					body += "</td><td align='center'>";

					body += "</td></tr></table>";


					span.innerHTML = body
				}

				function clearAll(){
					var spans = document.getElementsByTagName('span');
					for(var i = 0; i < spans.length; i++){
						var span = spans\[i\];

						var id = span.getAttribute("id");

						if(!(id.indexOf("item")==0))
							continue;

						var pass = 1;

						for(var j = 0; j < locked_tabs.length; j++){
							if(locked_tabs\[j\]==id){
								pass = 0;
								break;
							}
						}

						if(pass != 1)
							continue;




						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id){
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if(decision == "1"){
						link.setAttribute("name","2");
					}else{
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 0;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<font color='red'>Locked</font> ";
					//link.setAttribute("onClick","attempt('"+id+"','"+link_id+"','"+notice_span_id+"');");
					//document.write("removeFromLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
					//document.write("aa - "+link.getAttribute("onClick"));
				}

				function attempt(ab){
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id){
					//document.write("a");
					var index = 0;
					var pass = 0;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 1;
							index = j;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs\[index\] = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
					//var link = document.getElementById(link_id);
					//link.setAttribute("onClick","addToLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"

	//title + search bar
	dat += {"

		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Upgrade Menu</b></font><br>
					Hover over an upgrade to see more information<br>
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter' value='' style='width:300px;'>
				</td>
			</tr>
	</table>

	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/i = 1
	for(var/datum/borer_upgrade/U in upgrades)

		if(U.evil && !B.evil)
			continue

		if(U.good && B.evil)
			continue

		var/list/purchased = params2list(list2params(B.purchasedupgrades))
		var/list/required = U.requirements&purchased

		if(!U.requirements) // show them if they have no requirements
		else if(U.requirements.len == required.len) // show them if they have and meet their requirements
		else
			continue // otherwise dont show them

		var/ownsthis = has_upgrade(U)

		var/color
		if(ownsthis)
			if(i%2 == 0)
				color = "#d8ebd8"
			else
				color = "#c3dec3"
		else
			if(i%2 == 0)
				color = "#f2f2f2"
			else
				color = "#e6e6e6"


		dat += {"

			<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
				<td align='center' bgcolor='[color]'>
					<span id='notice_span[i]'></span>
					<a id='link[i]'
					onmouseover='expand("item[i]","[U.name]","[U.desc]","[U.helptext]","[U]",[ownsthis])'
					>
					<b id='search[i]'>Evolve [U][ownsthis ? " - Purchased" : ((U.chem_cost > 1) ? " - Cost: [U.chem_cost]" : "")]</b>
					</a>
					<br><span id='item[i]'></span>
				</td>
			</tr>

		"}

		i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var maintable = document.getElementById("maintable_data_archive");
			var complete_list = maintable.innerHTML;
		</script>
	</body></html>
	"}
	return dat


/mob/living/simple_animal/borer/Topic(href, href_list)
	..()

	if(href_list["U"])
		purchaseUpgrade(usr, href_list["U"])
	var/dat = create_menu(usr)
	usr << browse(dat, "window=upgrades;size=600x700")

/mob/living/simple_animal/borer/proc/purchaseUpgrade(var/mob/living/simple_animal/borer/user, var/upgrade_name)
	var/datum/borer_upgrade/theupgrade = null

	for(var/datum/borer_upgrade/S in upgrades)
		if(S.name == upgrade_name)
			theupgrade = S

	if(theupgrade == null)
		user << "This is awkward. Borer upgrade purchase failed, please report this bug to a coder!"
		return

	if(chemicals < theupgrade.chem_cost)
		user << "You do not have enough chemicals to do this."
		return

	if(has_upgrade(theupgrade))
		user << "You have already evolved this ability!"
		return

	chemicals -= theupgrade.chem_cost
	purchasedupgrades += theupgrade
	theupgrade.on_purchase(user)

/mob/living/simple_animal/borer/proc/has_upgrade(datum/borer_upgrade/upgrade)
	for(var/datum/borer_upgrade/U in purchasedupgrades)
		if(upgrade.name == U.name)
			return 1
	return 0
