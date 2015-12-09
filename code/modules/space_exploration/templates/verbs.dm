/client/proc/LoadTemplate()
	set name = "Load Template"
	set category = "Debug"

	var/list/categories = template_controller.GetCategories(1)

	var/category = input("Which category?", "Input") as anything in categories + "Cancel"

	var/list/templates

	if(category == "Cancel")
		return

	templates = flist("data/templates/[category]/")

	var/name = input("Which Template?", "Selection") in templates

	name = "data/templates/[category]/[name]"

	if(!fexists(name))
		usr << "[name] does not exist."
		return

	template_controller.PlaceTemplateAt(get_turf(mob), name)