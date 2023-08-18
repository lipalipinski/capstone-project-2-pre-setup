// use in jenkins console

def pluginList = new ArrayList(Jenkins.instance.pluginManager.plugins)

println ("plugins:")
pluginList.sort { it.getShortName() }.each{
  plugin -> 
  	println ("  # ${plugin.getDisplayName()}")
  	println ("  - artifactId: ${plugin.getShortName()}")
    println ("    source:")                  
    println ("      version: ${plugin.getVersion()}\n")
}