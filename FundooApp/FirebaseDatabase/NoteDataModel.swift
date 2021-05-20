class NoteDataModel
{
    static func addTask(title:String,description:String) -> [String:Any]
    {
        let dict = ["title":title,"description":description, "timestamp":[".sv":"timestamp"]] as [String:Any]
        return dict
    }
}
