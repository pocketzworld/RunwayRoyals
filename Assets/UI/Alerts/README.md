# Interactive Notifications

## Description

This resource is a simple notification system that can be used to display messages to players. It is highly customizable and can be used to create alerts, notifications, and more.

## Features

- Locally and globally displayed notifications
- 4 different types of notifications
- Easy to use
- Responsive design
- Clickable notifications

## Installation

1. Download the latest version.
2. Extract the downloaded folder into your project directory.
3. Create an `EmptyObject` in the `Hierarchy` and name it `Alert`.
4. Drag and drop both files `pNotify.lua` and `pnoty.lua` into the `Alert` object.
5. Set the `pnoty.lua` output to `Above Chat` in the `Properties` tab.
6. Insert the `Sounds/alertsound.asset` into the `alertSound` property in the `pNotify.lua` script.
7. Play and enjoy!

## Usage

To use this resource, you can simply call the `pNotify` function with the following parameters:

```lua
local pNotify = require("pNotify")
```

To display a notification locally, you can use the following code:

```lua
pNotify.Notify({
  type = "default",
  title = "Welcome back!",
  text = client.localPlayer.name .. " it's good to see you again!",
  timeout = 5,
  autoHide = true,
  scope = "local",
  player = client.localPlayer
})
```

To display a notification globally, you can use the following code:

```lua
pNotify.Notify({
  type = "default",
  title = "Welcome back!",
  text = client.localPlayer.name .. " it's good to see you again!",
  timeout = 5,
  autoHide = true,
  scope = "global"
})
```

## Parameters

- `type` (string): The type of notification to display. Can be `default`, `success`, `error`, or `warning`.
- `title` (string): The title of the notification.
- `text` (string): The text of the notification.
- `timeout` (number): The time in seconds before the notification disappears.
- `autoHide` (boolean): Whether the notification should automatically hide after the timeout.
- `scope` (string): The scope of the notification. Can be `local` or `global`.
- `player` (Player): The player to display the notification to. Only required if the scope is `local`.

## Video Tutorial

<iframe width="100%" height="100%" style={{"aspect-ratio":"16/9"}} src="https://www.youtube.com/embed/eqofWbfBhEk" title="YouTube Video Player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Contributing

This resource is open-source and contributions are welcome. If you would like to contribute, please fork the repository and submit a pull request.
