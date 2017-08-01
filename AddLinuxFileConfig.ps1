Configuration AddLinuxFileConfig
{ 
    Import-DSCResource -ModuleName nx 
    Node "localhost" 
    {
        nxFile DirectoryExample
        {
            Ensure = "Present"
            DestinationPath = "/tmp/dir"
            Type = "Directory"
        } #end resource
        nxFile FileExample
        {
            Ensure = "Present"
            Destinationpath = "/tmp/dir/file"
            Contents="hello world `n"
            Type = "File"
            DependsOn = "[nxFile]DirectoryExample"
        } #end resource 
    } #end node
} #end configuration