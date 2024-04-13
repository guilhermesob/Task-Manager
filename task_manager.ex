defmodule TaskManager do
 defstruct id: 0, description: "", created_at: nil, completed_at: nil

 def create_task(description) do
    %TaskManager{
      id: generate_id(),
      description: description,
      created_at: DateTime.utc_now()
    }
 end

 def list_tasks(tasks) do
    Enum.each(tasks, fn task ->
      IO.puts("ID: #{task.id} - Description: #{task.description} - Created At: #{task.created_at}")
    end)
 end

 def update_task(tasks, id) do
    Enum.map(tasks, fn task ->
      if task.id == id do
        %TaskManager{task | completed_at: DateTime.utc_now()}
      else
        task
      end
    end)
 end

 def delete_task(tasks, id) do
    Enum.filter(tasks, fn task -> task.id != id end)
 end

 defp generate_id() do
    Process.registered()[:task_id] ||= 0
    Process.registered()[:task_id] = Process.registered()[:task_id] + 1
 end
end

defmodule TaskManagerCLI do
 def start() do
    tasks = []
    loop(tasks)
 end

 def loop(tasks) do
    IO.puts("""
    Choose an option:
    1. Add a task
    2. List tasks
    3. Complete a task
    4. Delete a task
    5. Quit
    """)

    input = IO.gets("") |> String.trim()

    case input do
      "1" -> tasks = add_task(tasks)
      "2" -> tasks = list_tasks(tasks)
      "3" -> tasks = complete_task(tasks)
      "4" -> tasks = delete_task(tasks)
      "5" -> quit()
      _ -> IO.puts("Invalid option. Please try again.")
    end

    loop(tasks)
 end

 def add_task(tasks) do
    IO.puts("Enter task description:")
    description = IO.gets("") |> String.trim()

    new_task = TaskManager.create_task(description)
    updated_tasks = tasks ++ [new_task]
    IO.puts("Task added successfully.")
    updated_tasks
 end

 def list_tasks(tasks) do
    IO.puts("Tasks:")
    TaskManager.list_tasks(tasks)
    tasks
 end

 def complete_task(tasks) do
    IO.puts("Enter the ID of the task to mark as completed:")
    id = IO.gets("") |> String.trim() |> String.to_integer()

    updated_tasks = TaskManager.update_task(tasks, id)
    IO.puts("Task marked as completed.")
    updated_tasks
 rescue
    ArgumentError -> IO.puts("Invalid ID. Please try again.")
    tasks
 end

 def delete_task(tasks) do
    IO.puts("Enter the ID of the task to delete:")
    id = IO.gets("") |> String.trim() |> String.to_integer()

    updated_tasks = TaskManager.delete_task(tasks, id)
    IO.puts("Task deleted.")
    updated_tasks
 rescue
    ArgumentError -> IO.puts("Invalid ID. Please try again.")
    tasks
 end

 def quit() do
    IO.puts("Exiting...")
    :ok
 end
end

TaskManagerCLI.start()
