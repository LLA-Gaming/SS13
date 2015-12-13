/client/proc/LoadTemplate()
	set name = "Load Template"
	set category = "Debug"

	var/list/categories = template_controller.GetCategories(1)

	var/category = input("Which category?", "Input") as anything in categories + "Cancel"

	var/list/templates

	if(category == "Cancel")
		return

	templates = flist("[template_config.directory]/[category]/")

	var/name = input("Which Template?", "Selection") in templates

	var/path = "[template_config.directory]/[category]/[name]"

	if(!fexists(path))
		usr << "[name] does not exist."
		return

	template_controller.placed_templates += template_controller.PlaceTemplateAt(get_turf(mob), path, name)
