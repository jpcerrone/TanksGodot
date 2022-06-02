# Get godot exe path from settings.json
$SettingsObject = Get-Content -Path .vscode\settings.json | ConvertFrom-Json
$godotExe = $SettingsObject.'godot_tools.editor_path'

#Run godot
& $godotExe --path $PSScriptRoot