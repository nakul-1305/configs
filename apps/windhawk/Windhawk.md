# Windhawk Configuration

This configuration is tailored for a 1920×1080 display at 100% scaling.  
Adjust values such as margins if needed (example: `625` in Notification Center Styler).  

---

**Disclaimer:**
These Windhawk settings work for me, but may not work as intended for you. I am not responsible for any problems, malfunctions, or unexpected behavior that may occur on your system.
Apply at your own risk.  

---

## Better file sizes in Explorer details

```json
{
  "calculateFolderSizes": "disabled",
  "sortSizesMixFolders": 1,
  "disableKbOnlySizes": 1,
  "useIecTerms": 0
}
```

---

## Taskbar Clock Customization

```json
{
  "ShowSeconds": 0,
  "TimeFormat": "hh':'mm tt",
  "DateFormat": "ddd',' MMM dd yyyy",
  "WeekdayFormat": "dddd",
  "WeekdayFormatCustom": "Sun, Mon, Tue, Wed, Thu, Fri, Sat",
  "TopLine": "%date% • %time%",
  "BottomLine": "",
  "MiddleLine": "",
  "TooltipLine": "",
  "Width": 180,
  "Height": 60,
  "MaxWidth": 0,
  "TextSpacing": 0,
  "WebContentsUpdateInterval": "",
  "TimeZones[0]": "",
  "TimeStyle.Hidden": 0,
  "TimeStyle.TextColor": "",
  "TimeStyle.TextAlignment": "",
  "TimeStyle.FontSize": 14,
  "TimeStyle.FontFamily": "",
  "TimeStyle.FontWeight": "Medium",
  "TimeStyle.FontStyle": "",
  "TimeStyle.FontStretch": "",
  "TimeStyle.CharacterSpacing": 4,
  "DateStyle.Hidden": 1,
  "DateStyle.TextColor": "",
  "DateStyle.TextAlignment": "",
  "DateStyle.FontSize": 0,
  "DateStyle.FontFamily": "",
  "DateStyle.FontWeight": "",
  "DateStyle.FontStyle": "",
  "DateStyle.FontStretch": "",
  "DateStyle.CharacterSpacing": 0,
  "oldTaskbarOnWin11": 0
}
```

---

## Taskbar height and icon size

```json
{
  "IconSize": 18,
  "TaskbarHeight": 36,
  "TaskbarButtonWidth": 33
}
```

---

## Taskbar Labels for Windows 11

```json
{
  "mode": "labelsWithoutCombining",
  "taskbarItemWidth": 0,
  "runningIndicatorStyle": "fullWidth",
  "progressIndicatorStyle": "sameAsRunningIndicatorStyle",
  "minimumTaskbarItemWidth": 50,
  "maximumTaskbarItemWidth": 180,
  "fontSize": 14,
  "fontFamily": "",
  "textTrimming": "clip",
  "leftAndRightPaddingSize": 8,
  "spaceBetweenIconAndLabel": 18,
  "runningIndicatorHeight": 4,
  "runningIndicatorVerticalOffset": 4,
  "alwaysShowThumbnailLabels": 1,
  "labelForSingleItem": "%name%",
  "labelForMultipleItems": "[%amount%] %name%"
}
```

---

## Taskbar on top for Windows 11

```json
{
  "taskbarLocation": "top",
  "taskbarLocationSecondary": "sameAsPrimary",
  "runningIndicatorsOnTop": 0
}
```

---

## Windows 11 Notification Center Styler

Note: Adjust the margin `625` depending on screen size or scaling.

```json
{
  "theme": "",
  "controlStyles[0].target": "Grid#ControlCenterRegion",
  "controlStyles[0].styles[0]": "Margin=0,0,0,625",
  "resourceVariables[0].variableKey": "",
  "resourceVariables[0].value": "",
  "controlStyles[1].target": "Grid#NotificationCenterGrid",
  "controlStyles[1].styles[0]": "VerticalAlignment=Stretch",
  "controlStyles[2].target": "Grid#CalendarCenterGrid",
  "controlStyles[2].styles[0]": "Margin=0,12,0,15",
  "controlStyles[3].target": "Windows.UI.Xaml.Controls.Grid#MediaTransportControlsRegion",
  "controlStyles[3].styles[0]": "Visibility=Collapsed"
}
```

---

## Windows 11 Start Menu Styler

```json
{
  "theme": "Down Aero",
  "disableNewStartMenuLayout": 1,
  "controlStyles[0].target": "",
  "controlStyles[0].styles[0]": "",
  "webContentStyles[0].target": "",
  "webContentStyles[0].styles[0]": "",
  "webContentCustomJs": "",
  "styleConstants[0]": "",
  "resourceVariables[0].variableKey": "",
  "resourceVariables[0].value": ""
}
```

---

## Windows 11 Taskbar Styler

```json
{
  "theme": "Squircle",
  "controlStyles[0].target": "Taskbar.ExperienceToggleButton#LaunchListButton[AutomationProperties.AutomationId=StartButton]",
  "controlStyles[0].styles[0]": "Visibility=Collapsed",
  "resourceVariables[0].variableKey": "",
  "resourceVariables[0].value": ""
}
```
