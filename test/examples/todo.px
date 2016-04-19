-- __doc__ field is a special field for attaching
-- documentation to objects
let task = {
   description = nil,
   completed = false,
   edits = nil,
   id = nil,
   __doc__ = "Object to represent a task"
};;

-- return a copy of the task model with updated fields
let new_task = fn desc, id ->
  task with { description = desc, id = id }
;;

{- An example long comment. This will be ignored.
type action =
  | Focus
  | Edit of string
  | Cancel
  | Commit
  | Completed of bool
  | Delete
-}

let tasks = ref []

for x in 0..5 do  end

for x in 0..5 do
  tasks := list.append(!tasks,new_task("cook",x)
end

for x in 0..5 do
  tasks := list.append(foo,x)
end

for task in tasks do
 println "#{task.id}: #{task.description}"
end
