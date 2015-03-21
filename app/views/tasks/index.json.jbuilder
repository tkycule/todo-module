json.array!(@tasks) do |task|
  json.extract! task, :id, :user_id, :title, :memo, :aasm_state
  json.url task_url(task, format: :json)
end
