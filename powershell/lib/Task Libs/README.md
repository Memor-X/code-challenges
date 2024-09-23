# Task Libraries
## Testing
Create an array if the functions to be used like

```
$commands = @(
    "Get-Task-Title",
    "Get-Task-Url"
)
```

and then pass `$commands` into `Test-Function-Loop` found in Common.ps1. otherwise can run each string in `Test-Function-Exists` individually

## Functions
### Get-Task-Title
- **Input:**
	- `$id` \<String\>
- **Output:** N/A
- **Description:**
	Fetches the Task Title

### Get-Task-Url
- **Input:**
	- `$id` \<String\>
- **Output:** N/A
- **Description:**
	Fetches the Task URL

### Add-Comment
- **Input:**
	- `$id` \<String\>
	- `$comment` \<String\>
- **Output:** N/A
- **Description:**
	Adds `$comment` to the task specified by `$id`

## Libraries
### NA.ps1
**Description:** Default library that doesn't actually use any API and instead returns static values
**XML Data:** N/A

### Test.ps1
**Description:** Similar to NA.ps1 but enforces debugging statements
**XML Data:** N/A

### Kanri.ps1
**Description:** Kanri Kanban Board Task Library - https://github.com/trobonox/kanri
**NOTES:**
- Format Task Titles as `[ID] - Title` so that the task can be found
**XML Data:**
```
<dat_loc>[.kanri.dat LOCATION]</loc>
<board_id>[BOARD ID]</board_id>
```